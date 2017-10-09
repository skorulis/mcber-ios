//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class BattleAttackModel: ImmutableMappable, ReferenceFillable {
    let damage:Int
    let attackSkillId: String
    let defenceSkillId: String
    
    var attackSkill:SkillRefModel!
    var defenceSkill:SkillRefModel!
    
    required init(map: Map) throws {
        damage = try map.value("damage")
        attackSkillId = try map.value("attackSkillId")
        defenceSkillId = try map.value("defenceSkillId")
    }
    
    func fill(ref: ReferenceService) {
        attackSkill = ref.skill(attackSkillId)
        defenceSkill = ref.skill(defenceSkillId)
    }
}

class BattleResultModel: ImmutableMappable, ReferenceFillable {

    let _id:String
    let winnerId:String
    let avatar1:AvatarModel
    let avatar2:AvatarModel
    let a1TotalDamage:Int
    let a2TotalDamage:Int
    
    let a1Attacks:[BattleAttackModel]
    let a2Attacks:[BattleAttackModel]
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        winnerId = try map.value("winnerId")
        avatar1 = try map.value("avatar1")
        avatar2 = try map.value("avatar2")
        
        a1TotalDamage = try map.value("a1TotalDamage")
        a2TotalDamage = try map.value("a2TotalDamage")
        
        a1Attacks = try map.value("a1Attacks")
        a2Attacks = try map.value("a2Attacks")
    }
    
    func fill(ref: ReferenceService) {
        avatar1.fill(ref: ref)
        avatar2.fill(ref: ref)
        a1Attacks.forEach { $0.fill(ref: ref)}
        a2Attacks.forEach { $0.fill(ref: ref)}
    }
    
}
