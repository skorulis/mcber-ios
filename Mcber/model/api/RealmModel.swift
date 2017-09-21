//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class RealmModel: ImmutableMappable, ReferenceFillable {

    let elementId:Int
    let level:Int
    var maximumLevel:Int?
    
    var refSkill:SkillRefModel!
    
    required init(map: Map) throws {
        elementId = try map.value("elementId")
        let max:Int? = try? map.value("maximumLevel")
        maximumLevel = max
        level = (try? map.value("level")) ?? max ?? 1
    }
    
    init(elementId:Int,level:Int,maximumLevel:Int?) {
        self.elementId = elementId
        self.level = level
        self.maximumLevel = maximumLevel
    }
    
    func fill(ref: ReferenceService) {
        self.refSkill = ref.skill(self.elementId)
    }
    
}
