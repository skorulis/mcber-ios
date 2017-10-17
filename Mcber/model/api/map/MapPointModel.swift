//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class MapPointModel: ImmutableMappable {

    let id:String
    let name:String
    let x:Int
    let y:Int
    let size:Int
    let level:Int
    
    required init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        size = try map.value("size")
        x = try map.value("x")
        y = try map.value("y")
        level = try map.value("level")
    }
    
    init(id:String,name:String,x:Int,y:Int,size:Int=40,level:Int=1) {
        self.id = id
        self.name = name
        self.size = size
        self.x = x
        self.y = y
        self.level = level
    }
}
