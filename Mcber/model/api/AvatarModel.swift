//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.
import UIKit
import ObjectMapper

enum SkillType: String {
    case element = "elemental"
    case trade = "trade"
}

class SkillProgressAPIModel: ImmutableMappable {
    
    let level:Int
    let xp:Int
    let xpNext:Int
    
    required init(map: Map) throws {
        level = try map.value("level")
        xp = try map.value("xp")
        xpNext = try map.value("xpNext")
    }
    
    init(level:Int,xp:Int,xpNext:Int) {
        self.level = level
        self.xp = xp
        self.xpNext = xpNext
    }
}

class SkillProgressModel: SkillProgressAPIModel {
    
    let skillId:Int
    let type:SkillType
    
    init(net:SkillProgressAPIModel,skillId:Int,type:SkillType) {
        self.skillId = skillId
        self.type = type
        super.init(level: net.level, xp: net.xp, xpNext:net.xpNext)
    }
    
    required init(map: Map) throws {
        skillId = try map.value("skillId")
        type = try map.value("skillType")
        try super.init(map: map)
    }
    
}

class AvatarSkills: ImmutableMappable {
    
    let elements:[SkillProgressModel]
    let trades:[SkillProgressModel];
    
    required init(map: Map) throws {
        let netElements:[SkillProgressAPIModel] = try map.value("elements")
        elements = netElements.enumerated().map { (index, element) in
            return SkillProgressModel(net: element, skillId: index,type:.element)
        }
        
        let netTrades:[SkillProgressAPIModel] = try map.value("trades")
        trades = netTrades.enumerated().map { (index, element) in
            return SkillProgressModel(net: element, skillId: index,type:.trade)
        }
    }
}

class AvatarModel: ImmutableMappable {

    let _id:String
    let level:Int
    let health:Int
    let speed:Int
    let skills:AvatarSkills
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        level = try map.value("level")
        health = try map.value("health")
        speed = try map.value("speed")
        skills = try map.value("skills")
    }
    
}
