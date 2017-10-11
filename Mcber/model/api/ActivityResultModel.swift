//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ActivityResult: ImmutableMappable, ReferenceFillable {
    
    let success:Bool
    let currency:Int
    let experience:[ExperienceGainModel]
    let resources:[ResourceModel]
    let realmUnlock:RealmModel?
    let item:ItemModel?
    let gem:ItemGemModel?
    let battleResult:BattleResultModel?
    let foundAvatar:AvatarModel?
    
    required init(map: Map) throws {
        currency = try map.value("currency")
        experience = try map.value("experience")
        resources = try map.value("resources")
        realmUnlock = try? map.value("realmUnlock")
        item = try? map.value("item")
        gem = try? map.value("gem")
        success = try map.value("success")
        battleResult = try? map.value("battleResult")
        foundAvatar = try? map.value("foundAvatar")
    }
    
    func fill(ref: ReferenceService) {
        self.experience.forEach { $0.fill(ref: ref) }
        resources.forEach { $0.fill(ref: ref) }
        realmUnlock?.fill(ref: ref)
        item?.fill(ref: ref)
        gem?.fill(ref: ref)
        battleResult?.fill(ref: ref)
        foundAvatar?.fill(ref: ref)
    }
}

class CombinedActivityResult {
    
    var title:String
    var resultCount:Int = 0
    var failureCount:Int = 0
    var currency:Int = 0
    var experience:[ExperienceGainModel] = []
    var resources:[ResourceModel] = []
    var realmUnlock:RealmModel?
    var items:[ItemModel] = []
    var gems:[ItemGemModel] = []
    var foundAvatars:[AvatarModel] = []
    
    init() {
        title = "Result"
    }
    
    convenience init(result:ActivityResult) {
        self.init()
        self.title = result.success ? "Success" : "Failure"
        self.add(result: result)
    }
    
    convenience init(resources:[ResourceModel]) {
        self.init()
        self.resources = resources
    }
    
    func add(result:ActivityResult) {
        resultCount = resultCount + 1
        if (!result.success) {
            failureCount = failureCount + 1
        }
        currency = currency + result.currency
        if let item = result.item {
            items.append(item)
        }
        if let gem = result.gem {
            gems.append(gem)
        }
        
        if let unlock = result.realmUnlock {
            realmUnlock = unlock
        }
        if let avatar = result.foundAvatar {
            foundAvatars.append(avatar)
        }
        for xp in result.experience {
            let matching = self.experience.filter { $0.skillId == xp.skillId }.first
            if let matching = matching {
                matching.xp += xp.xp
            } else {
                self.experience.append(xp)
            }
        }
        for res in result.resources {
            let matching = self.resources.filter { $0.resourceId == res.resourceId }.first
            if let matching = matching {
                matching.quantity += res.quantity
            } else {
                resources.append(res)
            }
        }
       
    }
    
    func itemCount() -> Int {
        return items.count
    }
    
    func itemAt(indexPath:IndexPath) -> ItemModel {
        return items[indexPath.row]
    }
    
    func gemCount() -> Int {
        return gems.count
    }
    
    func gemAt(indexPath:IndexPath) -> ItemGemModel {
        return gems[indexPath.row]
    }
    
}
