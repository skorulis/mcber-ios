//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

//Logic for performing activities
class ActivityService: NSObject {

    let api:MainAPIService
    let state:GameStateService
    
    init(api:MainAPIService,state:GameStateService) {
        self.api = api
        self.state = state
    }
    
    func explore(avatarId:String,realm:RealmModel) -> Promise<ActivityResponse> {
        let promise = api.explore(avatarId:avatarId,realm:realm)
        _ = promise.then { [unowned self] response -> Void in
            
        }
        return promise
    }
    
}
