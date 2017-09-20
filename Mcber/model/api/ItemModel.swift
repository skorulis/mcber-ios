//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

//TODO: Link up to reference items
class ItemModel: ImmutableMappable, ReferenceFillable {
    
    let id:String
    let name:String
    let mods:[ItemModModel];
    
    required init(map: Map) throws {
        id = try map.value("_id")
        name = try map.value("name")
        
        mods = try map.value("mods")
    }
    
    func fill(ref: ReferenceService) {
        mods.forEach { $0.fill(ref: ref) }
    }
}

class ItemModModel: ImmutableMappable, ReferenceFillable {
    
    let id:String
    let power:Int
    let skillId:Int
    
    var refSkill:SkillRefModel!
    var refMod:ItemModRef!
    
    required init(map: Map) throws {
        id = try map.value("id")
        power = try map.value("power")
        skillId = try map.value("elementId")
    }
    
    func fill(ref: ReferenceService) {
        refSkill = ref.skill(skillId)
        refMod = ref.itemMod(id)
    }
    
}


