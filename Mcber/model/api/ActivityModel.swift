//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

enum ActivityType: String {
    case explore = "explore"
    case battle = "battle"
}

class ExperienceGainModel: ImmutableMappable, ReferenceFillable {
    let type:SkillType
    let xp:Int
    let skillId:Int
    
    var refSkill:SkillModel!
    
    required init(map: Map) throws {
        type = try map.value("type")
        xp = try map.value("xp")
        skillId = try map.value("skillId")
    }
    
    func fill(ref: ReferenceService) {
        self.refSkill = ref.skill(skillId)
    }
}

class ActivityResult: ImmutableMappable, ReferenceFillable {
    
    let experience:[ExperienceGainModel]
    let resource:ResourceModel
    let realmUnlock:RealmModel?
    let item:ItemModel?
    
    required init(map: Map) throws {
        experience = try map.value("experience")
        resource = try map.value("resource")
        realmUnlock = try? map.value("realmUnlock")
        item = try? map.value("item")
    }
    
    func fill(ref: ReferenceService) {
        self.experience.forEach { $0.fill(ref: ref) }
        resource.fill(ref: ref)
        realmUnlock?.fill(ref: ref)
        item?.fill(ref: ref)
    }
}

class ActivityModel: ImmutableMappable, ReferenceFillable {

    let finishTimestamp:Double
    let startTimestamp:Double
    let _id:String
    let avatarId:String
    let activityType:ActivityType
    let realm:RealmModel?
    var autoRepeat:Bool = false
    
    required init(map: Map) throws {
        finishTimestamp = try map.value("finishTimestamp")
        startTimestamp = try map.value("startTimestamp")
        _id = try map.value("_id")
        avatarId = try map.value("avatarId")
        activityType = try map.value("activityType")
        realm = try? map.value("realm")
    }
    
    func fill(ref: ReferenceService) {
        realm?.fill(ref: ref)
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
