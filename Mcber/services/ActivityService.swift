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
    
    func handleActivityResponse(promise:Promise<ActivityResponse>,continuing:ActivityModel?) {
        _ = promise.then { [unowned self] response -> Void in
            response.activity.autoRepeat = (continuing != nil)
            response.activity.heldResults = continuing?.heldResults ?? CombinedActivityResult()
            self.state.add(activity:response.activity)
        }
    }
    
    func explore(avatarId:String,realm:RealmModel,continuing:ActivityModel? = nil) -> Promise<ActivityResponse> {
        let promise = api.explore(avatarId:avatarId,realm:realm)
        handleActivityResponse(promise: promise, continuing: continuing)
        return promise
    }
    
    func craft(avatarId:String,itemRefId:String,continuing:ActivityModel? = nil) -> Promise<ActivityResponse> {
        let promise = api.craft(avatarId: avatarId, itemRefId: itemRefId)
        handleActivityResponse(promise: promise, continuing: continuing)
        return promise
    }
    
    func craftGem(avatarId:String, gem:ActivityGemModel,continuing:ActivityModel? = nil) -> Promise<ActivityResponse> {
        let promise = api.craftGem(avatarId: avatarId, gem: gem)
        handleActivityResponse(promise: promise, continuing: continuing)
        return promise
    }
    
    func socketGem(avatarId:String, socket:ActivitySocketGemModel,continuing:ActivityModel? = nil) -> Promise<ActivityResponse> {
        let promise = api.socketGem(avatarId: avatarId, socket: socket)
        handleActivityResponse(promise: promise, continuing: continuing)
        return promise
    }
    
    func restartActivity(activity:ActivityModel) -> Promise<ActivityResponse> {
        switch (activity.activityType) {
        case .explore:
            return explore(avatarId: activity.avatarId, realm: activity.realm!,continuing: activity)
        case .craft:
            return craft(avatarId: activity.avatarId, itemRefId: activity.itemId!, continuing: activity)
        case .craftGem:
            return craftGem(avatarId: activity.avatarId, gem: activity.gem!)
        case .socketGem:
            return socketGem(avatarId: activity.avatarId, socket: activity.socketGem!)
        }
    }
    
    func complete(activity:ActivityModel) -> Promise<ActivityCompleteResponse> {
        let promise = api.complete(activityId:activity._id)
        _ = promise.then { [unowned self] response -> Void in
            self.state.update(activities:response.activities)
            self.state.update(avatar:response.avatar)
            for res in response.result.resources {
                self.state.add(resource: res)
            }
            
            if let realm = response.result.realmUnlock {
                self.state.add(realm:realm)
            }
            if let item = response.result.item {
                self.state.add(item: item)
            }
            if let gem = response.result.gem {
                self.state.add(gem: gem)
            }
            self.state.add(currency: response.result.currency)
            
            if activity.autoRepeat {
                activity.heldResults.add(result:response.result)
                _ = self.restartActivity(activity: activity)
            }
        }
        return promise
    }
    
    func battle(avatar:AvatarModel,realm:RealmModel) -> Promise<ActivityCompleteResponse> {
        let promise = self.api.battle(avatarId: avatar._id, realm: realm);
        return promise
    }
    
    @objc func checkActivities() {
        let time = Date().timeIntervalSince1970
        for a in state.activities {
            if a.autoRepeat && a.finishTimestamp < time {
                _ = self.complete(activity: a)
            }
        }
    }
    
}
