//  Created by Alexander Skorulis on 13/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

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

    init() {
        var baseURL:String = ""
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            baseURL = "http://localhost:8811/api"
        #else
            baseURL = "http://192.168.1.2:8811/api"
        #endif
        
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
    
    func getCurrentUser() -> Promise<UserResponse> {
        let req = self.request(path: "user/current")
        return doRequest(req: req)
    }
    
}
