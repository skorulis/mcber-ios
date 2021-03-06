//  Created by Alexander Skorulis on 24/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class UserService: NSObject {

    let api:MainAPIService
    let state:GameStateService
    
    init(api:MainAPIService,state:GameStateService) {
        self.api = api
        self.state = state
        super.init()
    }
    
    func buyAvatarSlot() -> Promise<UserResponse> {
        let promise = self.api.buyAvatarSlot()
        _ = promise.then { response -> Void in
            self.state.resetState(user: response.user)
        }
        return promise
    }
    
    func breakdown(item:ItemModel) -> Promise<BreakdownItemResponse> {
        let promise = self.api.breakdown(itemId: item._id)
        _ = promise.then { response -> Void in
            self.state.remove(item: item)
            response.resources.forEach({ (res) in
                self.state.add(resource:res)
            })
        }
        return promise
    }
    
    func breakdown(gem:ItemGemModel) -> Promise<BreakdownItemResponse> {
        let promise = self.api.breakdown(gemId: gem._id)
        _ = promise.then { response -> Void in
            self.state.remove(gem: gem)
            response.resources.forEach({ (res) in
                self.state.add(resource:res)
            })
        }
        return promise
    }
    
    func updateUserOptions(options:[UserOptionModel]) -> Promise<UserResponse> {
        let dict = options.map {["optionName":$0.optionName,"optionValue":$0.optionValue]}
        return self.api.updateOptions(options: dict)
        
    }
}
