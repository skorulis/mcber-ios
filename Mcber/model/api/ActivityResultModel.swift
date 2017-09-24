//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

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

class CombinedActivityResult {
    
    var experience:[ExperienceGainModel] = []
    var resources:[ResourceModel] = []
    var realmUnlock:RealmModel?
    var items:[ItemModel] = []
    
    init() {
        
    }
    
    convenience init(result:ActivityResult) {
        self.init()
        self.add(result: result)
    }
    
    convenience init(resources:[ResourceModel]) {
        self.init()
        self.resources = resources
    }
    
    func add(result:ActivityResult) {
        if let item = result.item {
            items.append(item)
        }
        if let unlock = result.realmUnlock {
            realmUnlock = unlock
        }
        for xp in result.experience {
            let matching = self.experience.filter { $0.skillId == xp.skillId }.first
            if let matching = matching {
                matching.xp += xp.xp
            } else {
                self.experience.append(xp)
            }
        }
        let matching = self.resources.filter { $0.resourceId == result.resource.resourceId }.first
        if let matching = matching {
            matching.quantity += result.resource.quantity
        } else {
            resources.append(result.resource)
        }
    }
    
    func itemCount() -> Int {
        return items.count
    }
    
    func itemAt(indexPath:IndexPath) -> ItemModel {
        return items[indexPath.row]
    }
    
}
