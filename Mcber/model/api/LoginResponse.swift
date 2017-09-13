//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class LoginResponse: ImmutableMappable {

    let authToken:String
    let authExpiry:Double
    
    let user:UserModel
    
    required init(map: Map) throws {
        authToken = try map.value("auth.token")
        authExpiry = try map.value("auth.expiry")
        user = try map.value("user")
    }
    
}
