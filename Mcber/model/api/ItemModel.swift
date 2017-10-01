//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ItemModel: ImmutableMappable, ReferenceFillable {
    
    let _id:String
    let name:String
    let type:String
    let mods:[ItemGemModel];
    
    var totalPower:Int {
        return mods.reduce(0, {x,y in  x + y.power })
    }
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        name = try map.value("name")
        type = try map.value("type")
        
        mods = try map.value("mods")
    }
    
    func fill(ref: ReferenceService) {
        mods.forEach { $0.fill(ref: ref) }
    }
    
    func modDescriptions() -> String {
        let a:[String] = self.mods.map { $0.userDescription() }
        return a.joined(separator: "\n")
    }
       
}


