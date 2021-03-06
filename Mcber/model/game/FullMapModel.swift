//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

struct MapBounds {
    var minX:Int = Int.max
    var minY:Int = Int.max
    var maxX:Int = Int.min
    var maxY:Int = Int.min
    
    init(points:[MapPointModel]) {
        for p in points {
            minX = min(minX, p.x-p.radius)
            minY = min(minY, p.y-p.radius)
            maxX = max(maxX, p.x+p.radius)
            maxY = max(maxY, p.y+p.radius)
        }
    }
    
    func rect() -> CGRect {
        return CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}

class FullMapModel {

    var points:[MapPointModel] = []
    var paths:[MapPathModel] = []
    var pointMap:[String:MapPointModel] = [:]
    var pathMap:[String:MapPathModel] = [:]
    
    init(points:[MapPointModel],paths:[MapPathModel]) {
        for p in points {
            add(point: p)
        }
        for p in paths {
            add(path: p)
        }
    }
    
    func fill(ref:ReferenceService) {
        for p in points {
            p.fill(ref: ref)
        }
    }
    
    func bounds() -> MapBounds {
        return MapBounds(points: self.points)
    }
    
    func overlaps(newPoint:MapPointModel,buffer:CGFloat) -> Bool {
        for p in points {
            let dist = p.center.distance(newPoint.center)
            if (dist < CGFloat(p.radius + newPoint.radius) + buffer) {
                return true
            }
        }
        return false
    }
    
    func add(point:MapPointModel) {
        points.append(point)
        pointMap[point.id] = point
    }
    
    func add(path:MapPathModel) {
        paths.append(path)
        pathMap[path.id] = path
    }
    
    func getPoint(_ pid:String) -> MapPointModel {
        return pointMap[pid]!
    }
    
    func nextPointId() -> String {
        var idNum = 1
        while true {
            let id = "\(idNum)"
            if pointMap[id] == nil {
                return id
            }
            idNum = idNum + 1
        }
    }
    
}
