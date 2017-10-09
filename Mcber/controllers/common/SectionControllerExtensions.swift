//  Created by Alexander Skorulis on 7/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension AutoSizeModelCell {
    
    static func defaultSection(object:ModelType,collectionView:UICollectionView) -> SectionController {
        let monitor = MonitoredObject(initialValue: object)
        return defaultObjectSection(data: monitor, collectionView: collectionView)
    }
    
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
    
    static func defaultObjectSection(data:MonitoredObject<ModelType>,collectionView:UICollectionView) -> SectionController {
        collectionView.register(clazz: self as! AnyClass)
        let section = SectionController()
        section.fixedCellCount = 1
        section.cellForItemAt = { (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell = curriedDefaultCell(getModel: data.elementAt(indexPath:))(collectionView,indexPath)
            return cell as! UICollectionViewCell
        }
        section.sizeForItemAt = curriedCalculateSize(getModel: data.elementAt(indexPath: ))
        
        return section
    }

    
}
