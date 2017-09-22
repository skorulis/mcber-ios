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

class AvatarItemSlot: ImmutableMappable, ReferenceFillable {
    let slotId:String
    let item:ItemModel?
    
    var slotRef:ItemSlotRef!
    
    required init(map: Map) throws {
        slotId = try map.value("slot")
        item = try? map.value("item")
    }
    
    func fill(ref: ReferenceService) {
        slotRef = ref.slot(slotId)
        item?.fill(ref: ref)
    }
}

class AvatarModel: ImmutableMappable, ReferenceFillable {

    let _id:String
    let level:Int
    let skills:[SkillProgressModel]
    let stats:AvatarStatsModel
    let items:[AvatarItemSlot]
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        level = try map.value("level")
        skills = try map.value("skills")
        stats = try map.value("stats")
        items = try map.value("items")
    }
    
    func fill(ref: ReferenceService) {
        skills.forEach { $0.fill(ref: ref) }
        stats.fill(ref: ref)
        items.forEach { $0.fill(ref: ref) }
    }
    
    func itemAt(slot:ItemSlotRef) -> ItemModel? {
        return items.filter { $0.slotId == slot.id }.first?.item
    }
    
}
