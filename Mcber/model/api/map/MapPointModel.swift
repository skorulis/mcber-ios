//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class MapPointAffiliation: ImmutableMappable {
    
    let skillId:String
    let value:Int
    
    var skill:SkillRefModel!
    
    required init(map: Map) throws {
        skillId = try map.value("skillId")
        value = try map.value("value")
    }
    
    init(skillId:String,value:Int) {
        self.skillId = skillId
        self.value = value;
    }
    
    func fill(ref:ReferenceService) {
        skill = ref.skill(skillId)
    }
}

class MapPointModel: ImmutableMappable {

    var id:String
    var name:String
    var center:CGPoint {
        didSet {
            x = Int(center.x)
            y = Int(center.y)
        }
    }
    var x:Int
    var y:Int
    var radius:Int
    var level:Int
    var affiliation:[MapPointAffiliation]
    
    required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        radius = try map.value("radius")
        x = try map.value("x")
        y = try map.value("y")
        center = CGPoint(x: x, y: y)
        level = try map.value("level")
        affiliation = try map.value("affiliation")
    }
    
    init(id:String,name:String,x:Int,y:Int,radius:Int=20,level:Int=1) {
        self.id = id
        self.name = name
        self.radius = radius
        self.x = x
        self.y = y
        self.center = CGPoint(x: x, y: y)
        self.level = level
        self.affiliation = []
    }
    
    func fill(ref:ReferenceService) {
        affiliation.forEach { $0.fill(ref: ref)}
    }
}
