//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class RealmModel: ImmutableMappable {

    let elementId:Int
    let level:Int
    
    required init(map: Map) throws {
        elementId = try map.value("elementId")
        level = try map.value("level") //TODO Handle maximum level values (or just change the name on the server)
    }
    
}
