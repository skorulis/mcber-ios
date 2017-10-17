//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapCollectionViewLayout: UICollectionViewLayout {

    var map:FullMapModel
    
    init(map:FullMapModel) {
        self.map = map
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var collectionViewContentSize: CGSize {
        return self.map.bounds().size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var items = [UICollectionViewLayoutAttributes]()
        
        let mapBounds = self.map.bounds()
        let xOffset = Int(mapBounds.origin.x)
        let yOffset = Int(mapBounds.origin.y)
        
        var index = 0;
        for point in map.points {
            let indexPath = IndexPath(item: index, section: 0)
            let att = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            att.frame = CGRect(x: point.x - point.radius - xOffset, y: point.y - point.radius - yOffset, width: point.radius * 2, height: point.radius * 2)
            items.append(att)
            index = index + 1
        }
        
        return items
    }
    
}
