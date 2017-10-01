//
//  GemModel.swift
//  Mcber
//
//  Created by Alexander Skorulis on 1/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.
//

import UIKit
import ObjectMapper

class ItemGemModel: ImmutableMappable, ReferenceFillable {
    
    let _id:String
    let refId:String
    let power:Int
    let skillId:String?
    
    var refSkill:SkillRefModel?
    var refMod:ItemModRef!
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        refId = try map.value("refId")
        power = try map.value("power")
        skillId = try? map.value("elementId")
    }
    
    func fill(ref: ReferenceService) {
        if let sId = skillId {
            refSkill = ref.skill(sId)
        }
        
        refMod = ref.itemMod(refId)
    }
    
    func totalAmount() -> Int {
        return self.power * refMod.powerMult
    }
    
    func userDescription() -> String {
        var text = refMod.descriptionFormatter.replacingOccurrences(of: "{{power}}", with: String(totalAmount()))
        if let refSkill = refSkill {
            text = text.replacingOccurrences(of: "{{skill}}", with: refSkill.name)
        }
        return text
    }
    
}
