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

class ItemSlotRef: ImmutableMappable {
    
    let id:String
    let name:String
    let types:[String]
    
    required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        types = try map.value("types")
    }
    
}


class ItemsReferenceModel: ImmutableMappable {
    
    let baseTypes:[ItemBaseTypeRef]
    let itemSlots:[ItemSlotRef]
    
    required init(map: Map) throws {
        baseTypes = try map.value("baseTypes")
        itemSlots = try map.value("itemSlots")
    }
}

class ItemReferenceResponse: ImmutableMappable {
    
    let items:ItemsReferenceModel
    
    required init(map: Map) throws {
        items = try map.value("items")
    }
    
}
