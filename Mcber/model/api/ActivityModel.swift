//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ActivityResult: ImmutableMappable {
    
    //TODO: Add fields
    
    required init(map: Map) throws {
        
    }
}

class ActivityModel: ImmutableMappable {

    let finishTimestamp:Double
    let startTimestamp:Double
    let _id:String
    let avatarId:String
    let activityType:String //TODO: Move to enum
    let realm:RealmModel?
    
    required init(map: Map) throws {
        finishTimestamp = try map.value("finishTimestamp")
        startTimestamp = try map.value("startTimestamp")
        _id = try map.value("_id")
        avatarId = try map.value("avatarId")
        activityType = try map.value("activityType")
        realm = try? map.value("realm")
    }
    
}

class ActivityResponse: ImmutableMappable {
    
    let activity:ActivityModel
    
    required init(map: Map) throws {
        activity = try map.value("activity")
    }
}

class ActivityCompleteResponse: ImmutableMappable {
    let activities:[ActivityModel]
    let result:ActivityResult
    let avatar:AvatarModel
    
    required init(map: Map) throws {
        activities = try map.value("activities")
        result = try map.value("result")
        avatar = try map.value("avatar")
    }
}
