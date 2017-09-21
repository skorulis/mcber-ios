//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

//Logic for performing activities
class ActivityService: NSObject {

    let api:MainAPIService
    let state:GameStateService
    var refreshTimer:Timer?
    
    init(api:MainAPIService,state:GameStateService) {
        self.api = api
        self.state = state
        super.init()
        self.refreshTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkActivities), userInfo: nil, repeats: true)
    }
    
    func explore(avatarId:String,realm:RealmModel,continuing:ActivityModel? = nil) -> Promise<ActivityResponse> {
        let promise = api.explore(avatarId:avatarId,realm:realm)
        _ = promise.then { [unowned self] response -> Void in
            response.activity.autoRepeat = (continuing != nil)
            response.activity.heldResults = continuing?.heldResults ?? CombinedActivityResult()
            self.state.add(activity:response.activity)
        }
        return promise
    }
    
    func restartActivity(activity:ActivityModel) -> Promise<ActivityResponse> {
        return explore(avatarId: activity.avatarId, realm: activity.realm!,continuing: activity)
    }
    
    func complete(activity:ActivityModel) -> Promise<ActivityCompleteResponse> {
        let promise = api.complete(activityId:activity._id)
        _ = promise.then { [unowned self] response -> Void in
            self.state.update(activities:response.activities)
            self.state.update(avatar:response.avatar)
            self.state.add(resource:response.result.resource)
            if let item = response.result.item {
                self.state.add(item: item)
            }
            
            if activity.autoRepeat {
                activity.heldResults.add(result:response.result)
                _ = self.restartActivity(activity: activity)
            }
        }
        return promise
    }
    
    func checkActivities() {
        let time = Date().timeIntervalSince1970
        for a in state.activities {
            if a.autoRepeat && a.finishTimestamp < time {
                _ = self.complete(activity: a)
            }
        }
    }
    
}
