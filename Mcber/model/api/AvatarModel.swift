//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.
import UIKit
import ObjectMapper

enum SkillType: String {
    case element = "elemental"
    case trade = "trade"
}

class SkillProgressModel: ImmutableMappable, ReferenceFillable {
    
    let level:Int
    let xp:Int
    let xpNext:Int
    let skillId:Int
    
    var ref:SkillRefModel!
    
    required init(map: Map) throws {
        level = try map.value("level")
        xp = try map.value("xp")
        xpNext = try map.value("xpNext")
        skillId = try map.value("id")
    }
    
    init(level:Int,xp:Int,xpNext:Int,skillId:Int) {
        self.level = level
        self.xp = xp
        self.xpNext = xpNext
        self.skillId = skillId
    }
    
    func fill(ref: ReferenceService) {
        self.ref = ref.skill(skillId)
    }
}

class AvatarModel: ImmutableMappable, ReferenceFillable {

    let _id:String
    let level:Int
    let health:Int
    let speed:Int
    let skills:[SkillProgressModel]
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        level = try map.value("level")
        health = try map.value("health")
        speed = try map.value("speed")
        skills = try map.value("skills")
    }
    
    func fill(ref: ReferenceService) {
        skills.forEach { $0.fill(ref: ref) }
    }
    
}
