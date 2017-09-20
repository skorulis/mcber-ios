//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum BaseItemType: String {
    case weapon = "weapon"
    case tool = "tool"
}

class ItemBaseTypeRef: ImmutableMappable {
    
    let name:String
    let type:BaseItemType
    
    required init(map: Map) throws {
        name = try map.value("name")
        type = try map.value("type")
    }
    
}


class ItemsReferenceModel: ImmutableMappable {
    
    let baseTypes:[ItemBaseTypeRef]
    
    required init(map: Map) throws {
        baseTypes = try map.value("baseTypes")
    }
}

class ItemReferenceResponse: ImmutableMappable {
    
    let items:ItemsReferenceModel
    
    required init(map: Map) throws {
        items = try map.value("items")
    }
    
}
