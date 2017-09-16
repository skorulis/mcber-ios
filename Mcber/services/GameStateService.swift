//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

//This service is purely for storing and notifying about state changes. It should not be doing any logic except for merging partial states
class GameStateService {

    let didChangeState = ObserverSet<UserModel>()
    
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
            user?.resources[index] = resourceTotal
        } else {
            user?.resources.append(resource)
        }
    }
    
    func update(activities:[ActivityModel]) {
        user?.activities = activities
        didChangeState.notify(parameters: user!)
    }
    
    func update(avatar:AvatarModel) {
        if let u = user {
            let index = u.avatars.index { $0._id == avatar._id }!
            u.avatars[index] = avatar
            didChangeState.notify(parameters: u)
        }
    }
    
}
