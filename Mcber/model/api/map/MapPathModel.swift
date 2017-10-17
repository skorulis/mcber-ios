//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class MapPathModel: ImmutableMappable {

    var id:String {
        return [point1Id,point2Id].sorted().joined(separator: "-")
    }
    
    let point1Id:String
    let point2Id:String
    let name:String?
    let discoveryChance:Double
    
    required init(map: Map) throws {
        point1Id = try map.value("point1Id")
        point2Id = try map.value("point2Id")
        name = try? map.value("name")
        discoveryChance = try map.value("discoveryChance")
    }
    
    init(point1Id:String,point2Id:String,discoveryChance:Double=0.1) {
        self.point1Id = point1Id
        self.point2Id = point2Id
        self.discoveryChance = discoveryChance
        self.name = nil
    }
    
}
