//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.
import UIKit
import ObjectMapper

class SkillProgressAPIModel: ImmutableMappable {
    
    let level:Int
    let xp:Int
    
    required init(map: Map) throws {
        level = try map.value("level")
        xp = try map.value("xp")
    }
    
    init(level:Int,xp:Int) {
        self.level = level
        self.xp = xp
    }
}

class SkillProgressModel: SkillProgressAPIModel {
    
    let elementId:Int
    
    init(net:SkillProgressAPIModel,elementId:Int) {
        self.elementId = elementId
        super.init(level: net.level, xp: net.xp)
    }
    
    required init(map: Map) throws {
        self.elementId = try map.value("elementId")
        try super.init(map: map)
    }
    
}

class AvatarSkills: ImmutableMappable {
    
    let elements:[SkillProgressModel]
    
    required init(map: Map) throws {
        let netElements:[SkillProgressAPIModel] = try map.value("elements")
        elements = netElements.enumerated().map { (index, element) in
            return SkillProgressModel(net: element, elementId: index)
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
