//  Created by Alexander Skorulis on 13/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit
import ObjectMapper

//TODO: Make this a bit more secure
private class TokenWriter: NetAPITokenWriter {
    private let kTokenKey = "kTokenKey"
    private let kTokenExpiryKey = "kTokenExpiry"
    private let userDefaults:UserDefaults = UserDefaults.standard
    
    var bearerToken:String?
    var bearerExpiry:Double?
    
    //MARK: NetAPIServiceDelegate
    
    init() {
        let token = readToken()
        bearerToken = token.0
        bearerExpiry = token.1
    }
    
    public func saveToken(token:String?,expiry:Double?) {
        self.userDefaults.set(token, forKey: kTokenKey)
        self.userDefaults.set(expiry ?? 0, forKey: kTokenExpiryKey)
        
        bearerToken = token
        bearerExpiry = expiry
    }
    
    public func readToken() -> (String?,Double?) {
        let token = self.userDefaults.string(forKey: kTokenKey)
        let expiry = self.userDefaults.double(forKey: kTokenExpiryKey)
        return (token,expiry)
    }
}


class MainAPIService: NetAPIService {

    let ref:ReferenceService
    
    init(ref:ReferenceService) {
        
        var baseURL:String = ""
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            baseURL = "http://localhost:8811/api"
        #else
            baseURL = "http://192.168.1.2:8811/api"
        #endif
        
        self.ref = ref
        super.init(baseURL: baseURL)
        self.tokenWriter = TokenWriter()
    }
    
    func signup(email:String,password:String) -> Promise<LoginResponse> {
        let req = self.formPostRequst(path: "signup", dict: ["email":email,"password":password])
        return doLoginRequest(req: req)
    }
    
    func login(email:String,password:String) -> Promise<LoginResponse> {
        let req = self.formPostRequst(path: "login/password", dict: ["email":email,"password":password])
        return doLoginRequest(req: req)
    }
    
    func refreshToken() -> Promise<LoginResponse> {
        var req = self.jsonPostRequest(path: "user/refreshToken", dict: [:])
        req.setValue("Bearer \(self.tokenWriter!.bearerToken!)", forHTTPHeaderField: "Authorization")
        return doLoginRequest(req: req)
    }
    
    func doLoginRequest(req:URLRequest) -> Promise<LoginResponse> {
        let promise:Promise<LoginResponse> = doRequest(req: req)
        _ = promise.then { login -> Void in
            self.tokenWriter?.saveToken(token: login.authToken, expiry: login.authExpiry)
        }
        return promise
    }
    
    func doAuthRequest<T: BaseMappable>(req:URLRequest) -> Promise<T> {
        var mutable = req
        if let token = self.tokenWriter?.bearerToken {
            mutable.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return doRequest(req: mutable)
    }
    
    func getCurrentUser() -> Promise<UserResponse> {
        let req = self.request(path: "user/current")
        return doAuthRequest(req: req)
    }
    
    func explore(avatarId:String,realm:RealmModel) -> Promise<ActivityResponse> {
        let dict = ["avatarId":avatarId,"realm":["elementId":realm.elementId,"level":realm.level]] as [String : Any]
        let req = self.jsonPostRequest(path: "action/explore", dict: dict)
        return doAuthRequest(req: req)
    }
    
    func craft(avatarId:String,itemRefId:String) -> Promise<ActivityResponse> {
        let dict = ["avatarId":avatarId,"itemName":itemRefId]
        let req  = self.jsonPostRequest(path: "action/craft", dict: dict)
        return doAuthRequest(req: req)
    }
    
    func complete(activityId:String) -> Promise<ActivityCompleteResponse> {
        let dict = ["activityId":activityId]
        let req = self.jsonPostRequest(path: "action/complete", dict: dict)
        return doAuthRequest(req: req)
    }
    
    func assignItem(itemId:String?,slot:String,avatarId:String) -> Promise<AssignItemResponse> {
        var dict = ["avatarId":avatarId,"slot":slot]
        if let itemId = itemId {
            dict["itemId"] = itemId
        }
        let req = self.jsonPostRequest(path: "item/assign", dict: dict)
        return doAuthRequest(req: req)
    }
    
    func breakdown(itemId:String) -> Promise<BreakdownItemResponse> {
        let req = self.jsonPostRequest(path: "item/breakdown", dict: ["itemId":itemId])
        return doAuthRequest(req: req)
    }
    
    override func parseData<T: BaseMappable>(data:Data?,connectionError:Error?) -> Promise<T> {
        let objPromise:Promise<T> = super.parseData(data: data, connectionError: connectionError)
        _ = objPromise.then { T -> Void in
            if let model = T as? ReferenceFillable {
                assert(self.ref.skills != nil)
                assert(self.ref.items != nil)
                assert(self.ref.mods != nil)
                assert(self.ref.resources != nil)
                model.fill(ref: self.ref)
            }
        }
        return objPromise
    }
    
}
