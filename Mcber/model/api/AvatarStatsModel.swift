//  Created by Alexander Skorulis on 22/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum StatType: String {
    case health = "1"
    case speed = "2"
}

class StatSkill: ImmutableMappable, ReferenceFillable {
    
    let id:String
    let level:Int
    
    var ref:SkillRefModel!
    
    required init(map: Map) throws {
        id = try map.value("id")
        level = try map.value("level")
    }
    
    func fill(ref:ReferenceService) {
        self.ref = ref.skill(self.id)
    }
}

class StatValue: ImmutableMappable, ReferenceFillable {
    
    let id:String
    let value:Double
    
    required init(map: Map) throws {
        id = try map.value("id")
        value = try map.value("value")
    }
    
    func fill(ref:ReferenceService) {
        
    }
    
}

class AvatarStatsModel: ImmutableMappable, ReferenceFillable {

    let skills:[StatSkill]
    let other:[StatValue]
    
    required init(map: Map) throws {
        skills = try map.value("skills")
        other = try map.value("otherStats")
    }
    
    func fill(ref:ReferenceService) {
        skills.forEach { $0.fill(ref: ref) }
        other.forEach { $0.fill(ref: ref) }
    }
    
    func otherValue(type:StatType) -> Double {
        return other.filter { $0.id == type.rawValue }.first!.value
    }
    
}
