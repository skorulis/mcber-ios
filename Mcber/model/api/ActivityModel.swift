//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum ActivityType: String {
    case explore = "explore"
    case battle = "battle"
    case craft = "craft"
}

class ExperienceGainModel: ImmutableMappable, ReferenceFillable {
    let type:SkillType
    var xp:Int
    let skillId:String
    
    var refSkill:SkillRefModel!
    
    required init(map: Map) throws {
        type = try map.value("type")
        xp = try map.value("xp")
        skillId = try map.value("skillId")
    }
    
    func fill(ref: ReferenceService) {
        self.refSkill = ref.skill(skillId)
    }
}

class ActivityCalculationsModel: ImmutableMappable {
    
    let duration:Double
    let skillLevel:Int
    let resources:[ResourceModel]
    
    required init(map: Map) throws {
        duration = try map.value("duration")
        skillLevel = try map.value("skillLevel")
        resources = (try? map.value("resources")) ?? []
    }
}

class ActivityModel: ImmutableMappable, ReferenceFillable {

    let startTimestamp:Double
    let _id:String
    let avatarId:String
    let activityType:ActivityType
    let calculated:ActivityCalculationsModel
    let realm:RealmModel?
    var autoRepeat:Bool = false
    
    var heldResults = CombinedActivityResult()
    
    required init(map: Map) throws {
        startTimestamp = try map.value("startTimestamp")
        _id = try map.value("_id")
        avatarId = try map.value("avatarId")
        activityType = try map.value("activityType")
        realm = try? map.value("realm")
        calculated = try map.value("calculated")
    }
    
    func fill(ref: ReferenceService) {
        realm?.fill(ref: ref)
    }
    
    var finishTimestamp:Double {
        return startTimestamp + calculated.duration
    }
    
}

class ActivityResponse: ImmutableMappable, ReferenceFillable {
    
    let activity:ActivityModel
    
    required init(map: Map) throws {
        activity = try map.value("activity")
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
