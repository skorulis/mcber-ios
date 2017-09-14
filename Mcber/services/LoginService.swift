//  Created by Alexander Skorulis on 18/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class LoginService {

    private let api:MainAPIService
    private let state:GameStateService
    
    let userDidLogout = ObserverSet<LoginService>()
    let userDidLogin = ObserverSet<LoginService>()
    
    init(api:MainAPIService,state:GameStateService) {
        self.api = api
        self.state = state
    }
    
    var isLoggedIn:Bool {
        return api.tokenWriter?.bearerToken != nil
    }
    
    func signup(email:String,password:String) -> Promise<LoginResponse> {
        let promise = api.signup(email: email, password: password)
        _ = promise.then {[unowned self] (response) -> Void in
            self.state.resetState(user: response.user)
            self.userDidLogin.notify(parameters: self)
        }
        return promise
    }
    
    func logout() {
        //TODO: Add logout here
        api.tokenWriter?.saveToken(token: nil, expiry: nil)
        userDidLogout.notify(parameters: self)
    }
    
}
