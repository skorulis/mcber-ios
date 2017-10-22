//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapCollectionViewLayout: UICollectionViewLayout {

    private let kEdgePadding:Int = 100
    
    var map:FullMapModel
    var zoomScale:CGFloat = 1
    var xOffset:Int = 0
    var yOffset:Int = 0
    
    init(map:FullMapModel) {
        self.map = map
        let mapBounds = self.map.bounds()
        
        xOffset = Int(mapBounds.minX) - kEdgePadding
        yOffset = Int(mapBounds.minY) - kEdgePadding
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        let size = self.map.bounds().rect().size
        return CGSize(width: (size.width+CGFloat(kEdgePadding*2)) * zoomScale, height: (size.height+CGFloat(kEdgePadding*2)) * zoomScale)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var items = [UICollectionViewLayoutAttributes]()
        
        var index = 0;
        
        for path in map.paths {
            let indexPath = IndexPath(item: index, section: 0)
            let att = MapLayoutAttributes(forCellWith: indexPath)
            let pathBounds = MapBounds(points: [path.point1,path.point2])
            let pathSize = pathBounds.rect().size
            
            let x = CGFloat(pathBounds.minX - xOffset) * zoomScale
            let y = CGFloat(pathBounds.minY - yOffset) * zoomScale
            let width = CGFloat(pathSize.width) * zoomScale
            let height = CGFloat(pathSize.height) * zoomScale
            
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
            
            let x = CGFloat(point.x - point.radius - xOffset) * zoomScale
            let y = CGFloat(point.y - point.radius - yOffset) * zoomScale
            let size = CGFloat(point.radius * 2) * zoomScale
            
            att.frame = CGRect(x: x, y: y, width: size, height: size)
            att.zIndex = 1
            items.append(att)
            index = index + 1
        }
        
        return items
    }
    
    func absoluteToMap(point:CGPoint) -> CGPoint {
        let x = (point.x - CGFloat(xOffset)) * zoomScale
        let y = (point.y - CGFloat(yOffset)) * zoomScale
        return CGPoint(x:x, y:y)
    }
    
    func viewToAbsolute(point:CGPoint) -> CGPoint {
        let x = (point.x)/zoomScale + CGFloat(xOffset)
        let y = (point.y)/zoomScale + CGFloat(yOffset)
        return CGPoint(x:x, y:y)
    }
    
}
