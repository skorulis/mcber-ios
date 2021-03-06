//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum BaseItemType: String {
    case weapon = "weapon"
    case tool = "tool"
    case shield = "shield"
    case helmet = "helmet"
    case hat = "hat"
    case shoes = "shoes"
    case boots = "boots"
    case sandals = "sandals"
    case shirt = "shirt"
    case vest = "vest"
}

class ItemBaseTypeRef: ImmutableMappable {
    
    let id:String
    let type:String
    let resources:[ResourceModel]
    
    required init(map: Map) throws {
        id = try map.value("id")
        type = try map.value("type")
        resources = try map.value("resources")
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
    
    let itemIdMap:[String:ItemBaseTypeRef]
    
    required init(map: Map) throws {
        baseTypes = try map.value("baseTypes")
        itemSlots = try map.value("itemSlots")
        
        var map = [String:ItemBaseTypeRef]()
        for item in baseTypes {
            map[item.id] = item
        }
        itemIdMap = map
    }
}

class ItemReferenceResponse: ImmutableMappable {
    
    let items:ItemsReferenceModel
    
    required init(map: Map) throws {
        items = try map.value("items")
    }
    
}
