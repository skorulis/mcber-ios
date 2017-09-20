//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

//TODO: Link up to reference items
class ItemModel: ImmutableMappable, ReferenceFillable {
    
    let mods:[ItemModModel];
    
    required init(map: Map) throws {
        mods = try map.value("mods")
    }
    
    func fill(ref: ReferenceService) {
        mods.forEach { $0.fill(ref: ref) }
    }
}

class ItemModModel: ImmutableMappable, ReferenceFillable {
    
    required init(map: Map) throws {
        
    }
    
    func fill(ref: ReferenceService) {
        
    }
    
}


