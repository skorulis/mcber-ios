//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ResourceModel: ImmutableMappable {
    
    let quantity:Int
    let resourceId:String
    
    required init(map: Map) throws {
        quantity = try map.value("quantity")
        resourceId = try map.value("id")
    }
    
    init(quantity:Int,resourceId:String) {
        self.quantity = quantity
        self.resourceId = resourceId
    }
    
}

class UserModel: ImmutableMappable {

    let _id:String
    let email:String?
    var avatars:[AvatarModel]
    let realms:[RealmModel]
    var activities:[ActivityModel]
    var resources:[ResourceModel]
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        email = try? map.value("email")
        avatars = try map.value("avatars")
        realms = try map.value("realms")
        activities = try map.value("activities")
        resources = try map.value("resources")
    }
    
}

class UserResponse: ImmutableMappable {
    
    let user:UserModel
    
    required init(map: Map) throws {
        user = try map.value("user")
    }
}
