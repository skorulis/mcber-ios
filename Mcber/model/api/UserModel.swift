//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class UserModel: ImmutableMappable {

    let _id:String
    let email:String?
    var avatars:[AvatarModel]
    let realms:[RealmModel]
    var activities:[ActivityModel]
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        email = try? map.value("email")
        avatars = try map.value("avatars")
        realms = try map.value("realms")
        activities = try map.value("activities")
    }
    
}

class UserResponse: ImmutableMappable {
    
    let user:UserModel
    
    required init(map: Map) throws {
        user = try map.value("user")
    }
}
