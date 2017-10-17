//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class FullMapModel {

    var points:[MapPointModel]
    var paths:[MapPathModel]
    
    init(points:[MapPointModel],paths:[MapPathModel]) {
        self.points = points
        self.paths = paths
        
        //TODO: Group map points to allow id lookup
    }
    
    func fill(ref:ReferenceService) {
        for p in points {
            p.fill(ref: ref)
        }
    }
    
    func bounds() -> CGRect {
        var minX:Int = 0
        var minY:Int = 0
        var maxX:Int = 0
        var maxY:Int = 0
        for p in points {
            minX = min(minX, p.x-p.radius)
            minY = min(minY, p.y-p.radius)
            maxX = max(maxX, p.x+p.radius)
            maxY = max(maxY, p.y+p.radius)
        }
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
    
    
    
}
