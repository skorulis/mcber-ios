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

class ItemModRef: ImmutableMappable {

    let type:String
    let postfix:String
    let elementalMultiplier:Int
    let tradeMultiplier:Int
    let plainMultiplier:Int
    let baseMultiplier:Int
    let power:Int
    let descriptionFormatter:String
    
    required init(map: Map) throws {
        type = try map.value("id")
        postfix = try map.value("postfix")
        elementalMultiplier = (try? map.value("elementalMultiplier")) ?? 0
        tradeMultiplier = (try? map.value("tradeMultiplier")) ?? 0
        plainMultiplier = (try? map.value("plainMultiplier")) ?? 0
        baseMultiplier = try map.value("baseMultiplier")
        power = try map.value("power")
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
