//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class SkillModel: ImmutableMappable {
    let name:String
    let shortName:String
    let damageModifiers:[Double]
    let id:Int
    let healthModifier:Double
    let speedModifier:Double
    let colorString:String
    let color:UIColor
    let type:SkillType
    
    required init(map: Map) throws {
        name = try map.value("name")
        shortName = try map.value("shortName")
        damageModifiers = try map.value("damageModifiers")
        healthModifier = try map.value("healthModifier")
        speedModifier = try map.value("speedModifier")
        id = try map.value("id")
        colorString = try map.value("color")
        type = try map.value("type")
        
        let colorNumber = Int(colorString,radix:16)!
        color = UIColor(netHex: colorNumber)
    }
}

class SkillsReferenceModel: ImmutableMappable {
    let skills:[SkillModel]
    
    let elements:[SkillModel]
    let trades:[SkillModel]
    
    required init(map: Map) throws {
        skills = try map.value("skills")
        elements = skills.filter { $0.type == .element }
        trades = skills.filter { $0.type == .trade }
    }
    
}

class SkillsRefResponse: ImmutableMappable {
    let skills:SkillsReferenceModel
    
    required init(map: Map) throws {
        skills = try map.value("skills")
    }
}
