//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

//This service is purely for storing and notifying about state changes. It should not be doing any logic except for merging partial states
class GameStateService {

    let didChangeState = ObserverSet<UserModel>()
    let didChangeAvatar = ObserverSet<AvatarModel>()
    
    var user:UserModel?
    
    var monitoredUser:MonitoredObject<UserModel>?
    let monitoredResources:MonitoredArray<ResourceModel> = MonitoredArray(array: [])
    let monitoredItems:MonitoredArray<ItemModel> = MonitoredArray(array: [])
    let monitoredGems:MonitoredArray<ItemGemModel> = MonitoredArray(array: [])
    
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
            didChangeState.add(object: monitoredUser!, self.monitoredUser!.updateIfEqual(newValue:))
        }
        monitoredUser?.watch(array: monitoredResources)
        monitoredUser?.watch(array: monitoredGems)
        monitoredUser?.watch(array: monitoredItems)
        
        monitoredResources.array = user.resources
        monitoredGems.array = user.gems
        monitoredItems.array = user.items
        
        didChangeState.notify(parameters: user)
    }
    
    func add(activity:ActivityModel) {
        user?.activities.append(activity)
        didChangeState.notify(parameters: user!)
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
        user?.items.append(item)
        didChangeState.notify(parameters: user!)
    }
    
    func add(realm:RealmModel) {
        let existing = user!.realms.filter { $0.elementId == realm.elementId }.first!
        existing.maximumLevel! = max(existing.maximumLevel!, realm.level)
    }
    
    func add(gem:ItemGemModel) {
        user?.gems.append(gem)
        didChangeState.notify(parameters: user!)
    }
    
    func update(activities:[ActivityModel]) {
        user?.activities = activities
        didChangeState.notify(parameters: user!)
    }
    
    func update(avatar:AvatarModel) {
        if let u = user {
            let index = u.avatars.index { $0._id == avatar._id }!
            u.avatars[index] = avatar
            didChangeAvatar.notify(parameters: avatar)
            didChangeState.notify(parameters: u)
        }
    }
    
    func remove(item:ItemModel) {
        monitoredItems.array = monitoredItems.array.filter { $0._id != item._id }
    }
    
    func remove(gem:ItemGemModel) {
        monitoredGems.array = monitoredGems.array.filter { $0._id != gem._id}
    }
    
    func monitor(avatar:AvatarModel) -> MonitoredObject<AvatarModel> {
        let m = MonitoredObject(initialValue: avatar)
        didChangeAvatar.add(object: m, m.updateIfEqual(newValue:))
        return m
    }
    
}
