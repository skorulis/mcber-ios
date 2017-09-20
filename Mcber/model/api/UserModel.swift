//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ResourceModel: ImmutableMappable, ReferenceFillable {
    
    let quantity:Int
    let resourceId:String
    
    var refModel:ResourceRefModel!
    
    required init(map: Map) throws {
        quantity = try map.value("quantity")
        resourceId = try map.value("id")
    }
    
    init(quantity:Int,resourceId:String) {
        self.quantity = quantity
        self.resourceId = resourceId
    }
    
    func fill(ref: ReferenceService) {
        self.refModel = ref.elementResource(self.resourceId)
    }
    
}

class UserModel: ImmutableMappable, ReferenceFillable {

    let _id:String
    let email:String?
    var avatars:[AvatarModel]
    let realms:[RealmModel]
    var activities:[ActivityModel]
    var resources:[ResourceModel]
    var items:[ItemModel];
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        email = try? map.value("email")
        avatars = try map.value("avatars")
        realms = try map.value("realms")
        activities = try map.value("activities")
        resources = try map.value("resources")
        items = try map.value("items")
    }
    
    func fill(ref: ReferenceService) {
        resources.forEach { $0.fill(ref: ref) }
        realms.forEach { $0.fill(ref: ref) }
        activities.forEach { $0.fill(ref: ref) }
        resources.forEach { $0.fill(ref: ref) }
        avatars.forEach { $0.fill(ref: ref) }
        items.forEach { $0.fill(ref: ref) }
    }
    
}

class UserResponse: ImmutableMappable, ReferenceFillable {
    
    let user:UserModel
    
    required init(map: Map) throws {
        user = try map.value("user")
    }
    
    func fill(ref: ReferenceService) {
        user.fill(ref: ref)
    }
}
