//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ItemModel: ImmutableMappable, ReferenceFillable {
    
    let id:String
    let name:String
    let type:String
    let mods:[ItemModModel];
    
    var totalPower:Int {
        return mods.reduce(0, { $0.0 + $0.1.power })
    }
    
    required init(map: Map) throws {
        id = try map.value("_id")
        name = try map.value("name")
        type = try map.value("type")
        
        mods = try map.value("mods")
    }
    
    func fill(ref: ReferenceService) {
        mods.forEach { $0.fill(ref: ref) }
    }
    
    func modDescriptions() -> String {
        let a:[String] = self.mods.map { $0.userDescription() }
        return a.joined(separator: "\n")
    }
       
}

class ItemModModel: ImmutableMappable, ReferenceFillable {
    
    let id:String
    let power:Int
    let skillId:Int?
    
    var refSkill:SkillRefModel?
    var refMod:ItemModRef!
    
    required init(map: Map) throws {
        id = try map.value("id")
        power = try map.value("power")
        skillId = try? map.value("elementId")
    }
    
    func fill(ref: ReferenceService) {
        if let sId = skillId {
            refSkill = ref.skill(sId)
        }
        
        refMod = ref.itemMod(id)
    }
    
    func totalAmount() -> Int {
        return self.power * refMod.baseMultiplier
    }
    
    func userDescription() -> String {
        var text = refMod.descriptionFormatter.replacingOccurrences(of: "{{power}}", with: String(totalAmount()))
        if let refSkill = refSkill {
            text = text.replacingOccurrences(of: "{{skill}}", with: refSkill.name)
        }
        return text
    }
    
}


