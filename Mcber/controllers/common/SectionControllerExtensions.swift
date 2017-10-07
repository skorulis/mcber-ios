//  Created by Alexander Skorulis on 7/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension AutoSizeModelCell {
    
    static func defaultArraySection(data:MonitoredArray<ModelType>,collectionView:UICollectionView) -> SectionController {
        
        collectionView.register(clazz: self as! AnyClass)
        let section = SectionController()
        
        section.simpleNumberOfItemsInSection = data.elementCount
        section.cellForItemAt = { (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = curriedDefaultCell(getModel: data.elementAt(indexPath:))(collectionView,indexPath)
            return cell as! UICollectionViewCell
        }
        
        section.sizeForItemAt = curriedCalculateSize(getModel: data.elementAt(indexPath:))
        
        return section
    }

    
}
