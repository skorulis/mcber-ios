//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapService: NSObject {

    func generateTestMap() -> FullMapModel {
        let maxVal:UInt32 = 1000
        
        let points = (0...100).map { (i) -> MapPointModel in
            let x = Int(arc4random_uniform(maxVal))
            let y = Int(arc4random_uniform(maxVal))
            let point = MapPointModel(id: String(i), name: String(i), x: x, y: y)
            let skillId = String(arc4random_uniform(9))
            
            point.affiliation = [MapPointAffiliation(skillId: skillId, value: 1)]
            return point
        }
        return FullMapModel(points: points, paths: [])
    }
    
}
