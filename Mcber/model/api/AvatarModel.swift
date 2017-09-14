//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.
import UIKit
import ObjectMapper

class SkillProgressModel: ImmutableMappable {
    
    let level:Int
    let xp:Int
    
    required init(map: Map) throws {
        level = try map.value("level")
        xp = try map.value("xp")
    }
}

class AvatarSkills: ImmutableMappable {
    
    let elements:[SkillProgressModel]
    
    required init(map: Map) throws {
        elements = try map.value("elements")
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
