//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum ItemModType: String {
    case skillPlus = "+skill"
    case healthPlus = "+health"
    case skillPct = "%skill"
    case extraAttack = "extra-attack"
}

enum GemSkillType: String {
    case none = "none"
    case all = "all"
    case elemental = "elemental"
    case trade = "trade"
}

class ItemModRef: ImmutableMappable {

    let type:String
    let postfix:String
    let skillType:GemSkillType
    let powerMult:Int
    let levelMult:Int
    let descriptionFormatter:String
    
    required init(map: Map) throws {
        type = try map.value("id")
        postfix = try map.value("postfix")
        skillType = try map.value("skillType")
        levelMult = try map.value("levelMult")
        powerMult = try map.value("power")
        descriptionFormatter = try map.value("descriptionFormatter")
    }
}

class ItemModsResponse: ImmutableMappable {
    
    let mods:[ItemModRef]
    let idMap:[String:ItemModRef]
    
    required init(map: Map) throws {
        mods = try map.value("mods")
        var map = [String:ItemModRef]()
        for m in mods {
            map[m.type] = m
        }
        idMap = map
    }
    
}
