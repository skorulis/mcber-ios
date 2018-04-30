//  Created by Alexander Skorulis on 22/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class LoreModel: ImmutableMappable {
    
    let id:String
    let text:String
    
    required init(map: Map) throws {
        id = try map.value("id")
        text = try map.value("text")
    }
}

class LoreResponse: ImmutableMappable {
    
    let lores:[LoreModel]
    let idMap:[String:LoreModel]
    
    required init(map: Map) throws {
        lores = try map.value("lores")
        idMap = Dictionary(grouping:lores,by: {$0.id}).mapValues { $0.first! }
    }
    
}
