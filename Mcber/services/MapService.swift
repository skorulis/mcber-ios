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
        mainCity.loreIds = ["1","2"]
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
        
        for skillIndex in 0...9 {
            let pid1 = "\(skillIndex)-\(4)"
            let pid2 = "\((skillIndex+1)%10)-\(4)"
            let point1 = map.getPoint(pid1)
            let point2 = map.getPoint(pid2)
            
            let midPid = "\(skillIndex)-\(skillIndex+1)-mid"
            var x = (point1.x + point2.x)/2
            var y = (point1.y + point2.y)/2
            
            let midPoint = MapPointModel(id: midPid, name: midPid, x: x, y: y)
            let angle = midPoint.center.angle()
            let mult:CGFloat = 130 + (4  * 60)
            x = Int(mult * sin(angle))
            y = Int(mult * cos(angle))
            
            midPoint.center = CGPoint(x: x, y: y)
            
            midPoint.level = 5
            midPoint.affiliation.append(contentsOf: point1.affiliation)
            midPoint.affiliation.append(contentsOf: point2.affiliation)
            map.add(point: midPoint)
            map.add(path:MapPathModel(point1: midPoint , point2: point1))
            map.add(path:MapPathModel(point1: midPoint , point2: point2))
        }
 
        for i in 0...200 {
            let x = Int(arc4random_uniform(maxVal)) - Int(maxVal/2)
            let y = Int(arc4random_uniform(maxVal)) - Int(maxVal/2)
            let point = MapPointModel(id: String(i), name: String(i), x: x, y: y)
            if map.overlaps(newPoint: point,buffer:20) {
                continue
            }
            let skillId = String(arc4random_uniform(9))
            
            let levelMid = Int(point.center.length()) / 80
            let levelBoundary = levelMid/5
            
            point.affiliation = [MapPointAffiliation(skillId: skillId, value: 1)]
            point.level = (levelMid - levelBoundary) + Int(arc4random_uniform(UInt32(levelBoundary*2)))
            map.add(point:point)
        }
        
        map.fill(ref: ref)
        return map
    }
    
    
}
