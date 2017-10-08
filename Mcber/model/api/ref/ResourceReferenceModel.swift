//  Created by Alexander Skorulis on 13/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ResourceRefModel: ImmutableMappable {

    let name:String
    let skillId:String?
    let id:String
    
    required init(map: Map) throws {
        name = try map.value("name")
        skillId = try? map.value("skill")
        id = try map.value("id")
    }
    
}

class ResourcesRefResponse: ImmutableMappable {
    
    let resources:[ResourceRefModel]
    let resourceMap:[String:ResourceRefModel]
    
    required init(map: Map) throws {
        resources = try map.value("resources")
        var map = [String:ResourceRefModel]()
        for r in resources {
            map[r.id] = r
        }
        resourceMap = map
    }
    
}
