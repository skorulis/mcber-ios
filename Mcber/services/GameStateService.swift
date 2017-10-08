//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

//This service is purely for storing and notifying about state changes. It should not be doing any logic except for merging partial states
class GameStateService {

    let didChangeState = ObserverSet<UserModel>()
    let didChangeRealms = ObserverSet<UserModel>()
    let didChangeAvatar = ObserverSet<AvatarModel>()
    
    var user:UserModel?
    
    var monitoredUser:MonitoredObject<UserModel>?
    
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
            user?.resources[index] = resourceTotal
        } else {
            user?.resources.append(resource)
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
        user!.items.array = user!.items.array.filter { $0._id != item._id }
    }
    
    func remove(gem:ItemGemModel) {
        user!.gems.array = user!.gems.array.filter { $0._id != gem._id}
    }
    
    func monitor(avatar:AvatarModel) -> MonitoredObject<AvatarModel> {
        let m = MonitoredObject(initialValue: avatar)
        didChangeAvatar.add(object: m, m.updateIfEqual(newValue:))
        return m
    }
    
}
