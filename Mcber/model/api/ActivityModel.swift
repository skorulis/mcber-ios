//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum ActivityType: String {
    case explore = "explore"
    case craft = "craft"
    case craftGem = "craft gem"
    case socketGem = "socket gem"
}

class ExperienceGainModel: ImmutableMappable, ReferenceFillable {
    var xp:Int
    let skillId:String
    
    var refSkill:SkillRefModel!
    
    required init(map: Map) throws {
        xp = try map.value("xp")
        skillId = try map.value("skillId")
    }
    
    func fill(ref: ReferenceService) {
        self.refSkill = ref.skill(skillId)
    }
}

class ActivityCalculationsModel: ImmutableMappable, ReferenceFillable {
    
    let duration:Double
    let skillLevel:Int
    let resources:[ResourceModel]
    
    required init(map: Map) throws {
        duration = try map.value("duration")
        skillLevel = try map.value("skillLevel")
        resources = (try? map.value("resources")) ?? []
    }
    
    func fill(ref: ReferenceService) {
        resources.forEach { $0.fill(ref: ref) }
    }
}

class ActivityGemModel: ImmutableMappable, ReferenceFillable {
    
    let elementId:String?
    let modId:String
    let level:Int
    
    var gemRef:ItemModRef!
    var skillRef:SkillRefModel?
    
    required init(map: Map) throws {
        elementId = try? map.value("elementId")
        modId = try map.value("modId")
        level = try map.value("level")
    }
    
    init(modId:String,level:Int, elementId:String?) {
        self.modId = modId
        self.level = level
        self.elementId = elementId
    }
    
    func fill(ref: ReferenceService) {
        gemRef = ref.itemMod(modId)
        if let e = elementId {
            skillRef = ref.skill(e)
        }
    }
}

class ActivitySocketGemModel: ImmutableMappable {
    let itemId:String
    let gemId:String
    
    required init(map: Map) throws {
        gemId = try map.value("gemId")
        itemId = try map.value("itemId")
    }
    
    init(gemId:String,itemId:String) {
        self.gemId = gemId
        self.itemId = itemId
    }
}

class ActivityModel: ImmutableMappable, ReferenceFillable {

    let startTimestamp:Double
    let _id:String
    let avatarId:String
    let activityType:ActivityType
    let calculated:ActivityCalculationsModel
    
    let realm:RealmModel?
    let itemId:String?
    let gem:ActivityGemModel?
    let socketGem:ActivitySocketGemModel?
    
    var autoRepeat:Bool = false
    
    var itemRef:ItemBaseTypeRef?
    
    var heldResults = CombinedActivityResult()
    
    required init(map: Map) throws {
        startTimestamp = try map.value("startTimestamp")
        _id = try map.value("_id")
        avatarId = try map.value("avatarId")
        activityType = try map.value("activityType")
        realm = try? map.value("realm")
        itemId = try? map.value("itemId")
        calculated = try map.value("calculated")
        gem = try? map.value("gem")
        socketGem = try? map.value("socketGem")
    }
    
    func fill(ref: ReferenceService) {
        realm?.fill(ref: ref)
        calculated.fill(ref: ref)
        if let itemId = itemId {
            itemRef = ref.item(itemId)
        }
        gem?.fill(ref: ref)
    }
    
    var finishTimestamp:Double {
        return startTimestamp + calculated.duration
    }
    
}

class ActivityResponse: ImmutableMappable, ReferenceFillable {
    
    let activity:ActivityModel
    let estimate:Bool
    let hasResources:Bool
    
    required init(map: Map) throws {
        activity = try map.value("activity")
        estimate = (try? map.value("estimate")) ?? false
        hasResources = (try? map.value("hasResources")) ?? true
    }
    
    func fill(ref: ReferenceService) {
        activity.fill(ref: ref)
    }
}

class ActivityCompleteResponse: ImmutableMappable, ReferenceFillable {
    let activities:[ActivityModel]
    let result:ActivityResult
    let avatar:AvatarModel
    
    required init(map: Map) throws {
        activities = try map.value("activities")
        result = try map.value("result")
        avatar = try map.value("avatar")
    }
    
    func fill(ref: ReferenceService) {
        activities.forEach { $0.fill(ref: ref) }
        result.fill(ref: ref)
        avatar.fill(ref: ref)
    }
}
