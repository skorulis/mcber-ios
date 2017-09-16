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
            self.state.add(activity:response.activity)
        }
        return promise
    }
    
    func complete(activity:ActivityModel) -> Promise<ActivityCompleteResponse> {
        let promise = api.complete(activityId:activity._id)
        _ = promise.then { [unowned self] response -> Void in
            self.state.update(activities:response.activities)
            self.state.update(avatar:response.avatar)
            self.state.add(resource:response.result.resource)
        }
        return promise
    }
    
}
