//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapService: NSObject {

    let ref:ReferenceService
    
    init(ref:ReferenceService) {
        self.ref = ref
    }
    
    func generateTestMap() -> FullMapModel {
        let maxVal:UInt32 = 2000
        
        let mainCity = MapPointModel(id: "kings_mountain", name: "Kings Peak", x: 0, y: 0,radius:100,level:0)
        var points = [MapPointModel]()
        
        for i in 0...100 {
            let x = Int(arc4random_uniform(maxVal)) - Int(maxVal/2)
            let y = Int(arc4random_uniform(maxVal)) - Int(maxVal/2)
            if abs(x) < 100 || abs(y) < 100 {
                continue
            }
            let point = MapPointModel(id: String(i), name: String(i), x: x, y: y)
            let skillId = String(arc4random_uniform(9))
            
            point.affiliation = [MapPointAffiliation(skillId: skillId, value: 1)]
            points.append(point)
        }
        
        for skillIndex in 0...9 {
            let angle = Double(skillIndex) * 2*Double.pi / 10
            let skillId = String(skillIndex)
            for pathIndex in 0...4 {
                let mult:Double = 130 + (Double(pathIndex)  * 60)
                let pointId = "\(skillIndex)-\(pathIndex)"
                let x = Int(mult * sin(angle))
                let y = Int(mult * cos(angle))
                let point = MapPointModel(id:pointId,name:pointId,x:x,y:y)
                point.affiliation = [MapPointAffiliation(skillId: skillId, value: 1)]
                points.append(point)
            }
        }
        
        points.append(mainCity)
        
        let map = FullMapModel(points: points, paths: [])
        map.fill(ref: ref)
        return map
    }
    
}
