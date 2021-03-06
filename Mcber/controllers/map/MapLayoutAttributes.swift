//  Created by Alexander Skorulis on 18/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapLayoutAttributes: UICollectionViewLayoutAttributes {

    var offsetX:Int = 0
    var offsetY:Int = 0
    var zoomScale:CGFloat = 1
    
    override func copy(with zone: NSZone? = nil) -> Any {
        let copy:MapLayoutAttributes = super.copy(with: zone) as! MapLayoutAttributes
        copy.offsetX = offsetX
        copy.offsetY = offsetY
        copy.zoomScale = zoomScale
        return copy
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let obj = object as? MapLayoutAttributes {
            return super.isEqual(object) && offsetX == obj.offsetX && offsetY == obj.offsetY && zoomScale == obj.zoomScale
        }
        return false
    }
    
}
