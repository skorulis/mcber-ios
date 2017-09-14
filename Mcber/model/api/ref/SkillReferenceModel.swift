//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ElementalSkillModel: ImmutableMappable {
    let name:String
    let shortName:String
    let damageModifiers:[Double]
    let index:Int
    let healthModifier:Double
    let speedModifier:Double
    //TODO: Put resources here?
    
    required init(map: Map) throws {
        name = try map.value("name")
        shortName = try map.value("shortName")
        damageModifiers = try map.value("damageModifiers")
        healthModifier = try map.value("healthModifier")
        speedModifier = try map.value("speedModifier")
        index = try map.value("index")
    }
}

class SkillsReferenceModel: ImmutableMappable {
    let elements:[ElementalSkillModel]
    
    required init(map: Map) throws {
        elements = try map.value("elements")
    }
    
}

class SkillsRefResponse: ImmutableMappable {
    let skills:SkillsReferenceModel
    
    required init(map: Map) throws {
        skills = try map.value("skills")
    }
}
