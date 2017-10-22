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
    
    var point1:MapPointModel!
    var point2:MapPointModel!
    
    required init(map: Map) throws {
        point1Id = try map.value("point1Id")
        point2Id = try map.value("point2Id")
        name = try? map.value("name")
        discoveryChance = try map.value("discoveryChance")
    }
    
    func mapping(map: Map) {
        id >>> map["id"]
        point1Id >>> map["point1Id"]
        point2Id >>> map["point2Id"]
        name >>> map["name"]
    }
    
    init(point1Id:String,point2Id:String,discoveryChance:Double=0.1) {
        self.point1Id = point1Id
        self.point2Id = point2Id
        self.discoveryChance = discoveryChance
        self.name = nil
    }
    
    init(point1:MapPointModel,point2:MapPointModel,discoveryChance:Double=0.1) {
        self.point1Id = point1.id
        self.point2Id = point2.id
        self.discoveryChance = discoveryChance
        self.name = nil
        
        self.point1 = point1
        self.point2 = point2
    }
    
}
