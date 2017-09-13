//  Created by Alexander Skorulis on 13/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ResourceRefModel: ImmutableMappable {

    let name:String
    let skill:Int
    //let _id:String
    
    required init(map: Map) throws {
        name = try map.value("name")
        skill = try map.value("skill")
    }
    
}

class ResourceListRefModel: ImmutableMappable {
    
    let elemental:[String:ResourceRefModel]
    
    required init(map: Map) throws {
        elemental = try map.value("elemental")
    }
}

class ResourcesRefResponse: ImmutableMappable {
    
    let resources:ResourceListRefModel
    
    required init(map: Map) throws {
        resources = try map.value("resources")
    }
    
}
