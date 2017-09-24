//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

//This service is purely for storing and notifying about state changes. It should not be doing any logic except for merging partial states
class GameStateService {

    let didChangeState = ObserverSet<UserModel>()
    let didChangeRealms = ObserverSet<UserModel>()
    let didChangeAvatar = ObserverSet<AvatarModel>()
    
    var user:UserModel?
    
    var hasState: Bool {
        return user != nil
    }
    
    var activities: [ActivityModel] {
        return user?.activities ?? []
    }
    
    var resources: [ResourceModel] {
        return user?.resources ?? []
    }
    
    var items: [ItemModel] {
        return user?.items ?? []
    }
    
    func clearState() {
        self.user = nil
    }
    
    func resetState(user:UserModel) {
        self.user = user
        didChangeState.notify(parameters: user)
    }
    
    func add(activity:ActivityModel) {
        user?.activities.append(activity)
        didChangeState.notify(parameters: user!)
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
        user!.items = user!.items.filter { $0._id != item._id }
    }
    
    func monitor(avatar:AvatarModel) -> MonitoredObject<AvatarModel> {
        let m = MonitoredObject(initialValue: avatar)
        didChangeAvatar.add(object: m, m.updateIfEqual(newValue:))
        return m
    }
    
}
