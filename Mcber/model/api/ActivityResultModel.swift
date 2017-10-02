//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ActivityResult: ImmutableMappable, ReferenceFillable {
    
    let experience:[ExperienceGainModel]
    let resource:ResourceModel?
    let realmUnlock:RealmModel?
    let item:ItemModel?
    let gem:ItemGemModel?
    
    required init(map: Map) throws {
        experience = try map.value("experience")
        resource = try? map.value("resource")
        realmUnlock = try? map.value("realmUnlock")
        item = try? map.value("item")
        gem = try? map.value("gem")
    }
    
    func fill(ref: ReferenceService) {
        self.experience.forEach { $0.fill(ref: ref) }
        resource?.fill(ref: ref)
        realmUnlock?.fill(ref: ref)
        item?.fill(ref: ref)
        gem?.fill(ref: ref)
    }
}

class CombinedActivityResult {
    
    var experience:[ExperienceGainModel] = []
    var resources:[ResourceModel] = []
    var realmUnlock:RealmModel?
    var items:[ItemModel] = []
    var gems:[ItemGemModel] = []
    
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
        if let gem = result.gem {
            gems.append(gem)
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
        if let resource = result.resource {
            let matching = self.resources.filter { $0.resourceId == resource.resourceId }.first
            if let matching = matching {
                matching.quantity += resource.quantity
            } else {
                resources.append(resource)
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
