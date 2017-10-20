//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapService: NSObject {

    let ref:ReferenceService
    
    init(ref:ReferenceService) {
        self.ref = ref
    }
    
    func generateTestMap() -> FullMapModel {
        let maxVal:UInt32 = 3000
        let map = FullMapModel(points: [], paths: [])
        
        let mainCity = MapPointModel(id: "kings_mountain", name: "Kings Peak", x: 0, y: 0,radius:100,level:0)
        map.add(point:mainCity)
        
        for skillIndex in 0...9 {
            let angle = Double(skillIndex) * 2*Double.pi / 10
            let angleRot = Double.pi / 20
            let skillId = String(skillIndex)
            var previousPoint:MapPointModel?
            for pathIndex in 0...4 {
                let movedAngle = angle + angleRot * Double(pathIndex)
                let mult:Double = 130 + (Double(pathIndex)  * 60)
                let pointId = "\(skillIndex)-\(pathIndex)"
                let x = Int(mult * sin(movedAngle))
                let y = Int(mult * cos(movedAngle))
                let point = MapPointModel(id:pointId,name:pointId,x:x,y:y)
                point.level = pathIndex + 1
                point.affiliation = [MapPointAffiliation(skillId: skillId, value: 1)]
                map.add(point:point)
                if let previous = previousPoint {
                    let path = MapPathModel(point1: previous, point2: point)
                    map.add(path:path)
                } else {
                    map.add(path:MapPathModel(point1: mainCity, point2: point))
                }
                previousPoint = point
            }
        }
        
        for i in 0...200 {
            let x = Int(arc4random_uniform(maxVal)) - Int(maxVal/2)
            let y = Int(arc4random_uniform(maxVal)) - Int(maxVal/2)
            let point = MapPointModel(id: String(i), name: String(i), x: x, y: y)
            if map.overlaps(newPoint: point,buffer:20) {
                continue
            }
            let skillId = String(arc4random_uniform(9))
            
            point.affiliation = [MapPointAffiliation(skillId: skillId, value: 1)]
            map.add(point:point)
        }
        
        map.fill(ref: ref)
        return map
    }
    
    
}
