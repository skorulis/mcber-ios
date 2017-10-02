//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StartActivityHelpers: NSObject {

    static func startSection(title:String,getEstimate: @escaping (IndexPath) -> ActivityViewModel?, startTarget:Any, startAction:Selector ) -> SectionController {
        let theme = ThemeService.theme!
        let startSection = SectionController()
        startSection.fixedFooterHeight = 40
        startSection.fixedCellCount = 0
        startSection.sizeForItemAt = ActivityEstimateCell.curriedCalculateSize(getModel: getEstimate)
        startSection.cellForItemAt = ActivityEstimateCell.curriedDefaultCell(getModel: getEstimate)
        
        startSection.simpleNumberOfItemsInSection =  {
            return getEstimate(IndexPath(row: 0, section: 0)) != nil ? 1 : 0
        }
        
        startSection.referenceSizeForHeader = { (collectionView:UICollectionView,layout:UICollectionViewLayout,section:Int) in
            return getEstimate(IndexPath(row: 0, section: 0)) != nil ? CGSize(width:collectionView.frame.width,height:40) : .zero
        }
        
        startSection.viewForSupplementaryElementOfKind = { (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            if (kind == UICollectionElementKindSectionHeader) {
                return SectionHeaderView.curriedHeaderFunc(theme: ThemeService.theme, text: "Preview")(collectionView,kind,indexPath)
            }
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: title)(collectionView,kind,indexPath)
            header.textColor = getEstimate(indexPath) != nil ? theme.color.defaultText : theme.color.disabledText
            header.addTapTarget(target: startTarget, action: startAction)
            return header
        }
        return startSection
    }
    
}
