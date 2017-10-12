//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

//This service is purely for storing and notifying about state changes. It should not be doing any logic except for merging partial states
class GameStateService {

    var user:UserModel?
    
    var monitoredUser:MonitoredObject<UserModel>?
    let monitoredResources:MonitoredArray<ResourceModel> = MonitoredArray(array: [])
    let monitoredItems:MonitoredArray<ItemModel> = MonitoredArray(array: [])
    let monitoredGems:MonitoredArray<ItemGemModel> = MonitoredArray(array: [])
    let monitoredAvatars:MonitoredArray<AvatarModel> = MonitoredArray(array: [])
    let monitoredActivities:MonitoredArray<ActivityModel> = MonitoredArray(array: [])
    
    init() {
        monitoredResources.observers.add(object: self) {[unowned self] (change) in
            self.user?.resources = change.array.array
        }
        monitoredGems.observers.add(object: self) {[unowned self] (change) in
            self.user?.gems = change.array.array
        }
        monitoredItems.observers.add(object: self) {[unowned self] (change) in
            self.user?.items = change.array.array
        }
        monitoredAvatars.observers.add(object: self) {[unowned self] (change) in
            self.user?.avatars = change.array.array
        }
        monitoredActivities.observers.add(object: self) {[unowned self] (change) in
            self.user?.activities = change.array.array
        }
    }
    
    var hasState: Bool {
        return user != nil
    }
    
    var activities: [ActivityModel] {
        return user?.activities ?? []
    }
    
    func clearState() {
        self.user = nil
    }
    
    func resetState(user:UserModel) {
        self.user = user
        if self.monitoredUser == nil {
            self.monitoredUser = MonitoredObject(initialValue: user)
        }
        monitoredUser?.watch(array: monitoredResources)
        monitoredUser?.watch(array: monitoredGems)
        monitoredUser?.watch(array: monitoredItems)
        monitoredUser?.watch(array: monitoredAvatars)
        monitoredUser?.watch(array:monitoredActivities)
        
        monitoredResources.array = user.resources
        monitoredGems.array = user.gems
        monitoredItems.array = user.items
        monitoredAvatars.array = user.avatars
        monitoredActivities.array = user.activities
    }
    
    func add(activity:ActivityModel) {
        monitoredActivities.array.append(activity)
    }
    
    func add(currency:Int) {
        user!.currency = user!.currency + currency
    }
    
    func add(resource:ResourceModel) {
        if let index = user?.resources.index(where: { $0.resourceId == resource.resourceId }) {
            let existing = user!.resources[index]
            let resourceTotal = ResourceModel(quantity: existing.quantity + resource.quantity, resourceId: existing.resourceId)
            resourceTotal.refModel = existing.refModel
            monitoredResources[index] = resourceTotal
        } else {
            monitoredResources.append(resource)
        }
    }
    
    func add(item:ItemModel) {
        monitoredItems.array.append(item)
    }
    
    func add(realm:RealmModel) {
        let existing = user!.realms.filter { $0.elementId == realm.elementId }.first!
        existing.maximumLevel! = max(existing.maximumLevel!, realm.level)
    }
    
    func add(gem:ItemGemModel) {
        monitoredGems.array.append(gem)
    }
    
    func update(activities:[ActivityModel]) {
        monitoredActivities.array = activities

    }
    
    func update(avatar:AvatarModel) {
        let index = self.monitoredAvatars.array.index { $0._id == avatar._id }!
        self.monitoredAvatars.array[index] = avatar
    }
    
    func remove(item:ItemModel) {
        monitoredItems.array = monitoredItems.array.filter { $0._id != item._id }
    }
    
    func remove(gem:ItemGemModel) {
        monitoredGems.array = monitoredGems.array.filter { $0._id != gem._id}
    }
    
    func monitor(avatar:AvatarModel) -> MonitoredObject<AvatarModel> {
        let m = MonitoredObject(initialValue: avatar)
        monitoredAvatars.observers.add(object: m) { (change) in
            for a in change.array.array {
                m.updateIfEqual(newValue: a)
            }
        }
        return m
    }
    
}
