//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapCollectionViewLayout: UICollectionViewLayout {

    var map:FullMapModel
    var zoomScale:Double = 1
    var xOffset:Int = 0
    var yOffset:Int = 0
    
    init(map:FullMapModel) {
        self.map = map
        let mapBounds = self.map.bounds()
        
        xOffset = Int(mapBounds.minX)
        yOffset = Int(mapBounds.minY)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        let size = self.map.bounds().rect().size
        return CGSize(width: Double(size.width)*zoomScale, height: Double(size.height)*zoomScale)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var items = [UICollectionViewLayoutAttributes]()
        
        
        
        var index = 0;
        
        for path in map.paths {
            let indexPath = IndexPath(item: index, section: 0)
            let att = MapLayoutAttributes(forCellWith: indexPath)
            let pathBounds = MapBounds(points: [path.point1,path.point2])
            let pathSize = pathBounds.rect().size
            
            let x = Double(pathBounds.minX - xOffset) * zoomScale
            let y = Double(pathBounds.minY - yOffset) * zoomScale
            let width = Double(pathSize.width) * zoomScale
            let height = Double(pathSize.height) * zoomScale
            
            att.frame = CGRect(x: x , y: y, width: width, height: height)
            att.offsetX = xOffset
            att.offsetY = yOffset 
            att.zoomScale = zoomScale
            
            items.append(att)
            index = index + 1
        }
        
        index = 0
        for point in map.points {
            let indexPath = IndexPath(item: index, section: 1)
            let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let x = Double(point.x - point.radius - xOffset) * zoomScale
            let y = Double(point.y - point.radius - yOffset) * zoomScale
            let size = Double(point.radius * 2) * zoomScale
            
            att.frame = CGRect(x: x, y: y, width: size, height: size)
            att.zIndex = 1
            items.append(att)
            index = index + 1
        }
        
        return items
    }
    
}
