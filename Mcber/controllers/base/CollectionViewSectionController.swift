//  Created by Alexander Skorulis on 10/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class SectionController: NSObject {
    
    var fillCellWidth:Bool = false
    var useAutoHeightCells:Bool = false
    
    var fixedSize:CGSize?
    var fixedHeight:CGFloat?
    var fixedCellCount:Int = 1
    
    var fixedHeaderHeight:CGFloat?
    
    var cellForItemAt: ((UICollectionView,IndexPath) -> UICollectionViewCell)!
    var didSelectItemAt: ((UICollectionView,IndexPath) -> () )?
    var sizeForItemAt: ((UICollectionView,UICollectionViewLayout, IndexPath) -> CGSize)?
    var viewForSupplementaryElementOfKind: ((UICollectionView,String,IndexPath) -> UICollectionReusableView)? 
    var numberOfItemsInSection: ((UICollectionView,Int) -> Int)?
    var simpleNumberOfItemsInSection: (() ->Int)?
    
    convenience init(fillCellWidth:Bool,useAutoHeightCells:Bool) {
        self.init()
        self.fillCellWidth = fillCellWidth
        self.useAutoHeightCells = useAutoHeightCells
    }
    
    convenience init(fixedHeight:CGFloat,cellForItemAt:((UICollectionView,IndexPath) -> UICollectionViewCell)!) {
        self.init()
        self.fixedHeight = fixedHeight
        self.cellForItemAt = cellForItemAt
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let block = numberOfItemsInSection {
            return block(collectionView,section)
        }
        if let block = simpleNumberOfItemsInSection {
            return block()
        }
        return fixedCellCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(cellForItemAt != nil) //Must be set by this point
        let cell = cellForItemAt(collectionView, indexPath)
        if self.fillCellWidth {
            cell.contentView.snp.remakeConstraints { (make) in
                make.width.equalTo(collectionView.frame.size.width)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if self.useAutoHeightCells {
            return UICollectionViewFlowLayoutAutomaticSize
        }
        
        let wid = collectionView.frame.size.width
        
        if let s = sizeForItemAt {
            return s(collectionView,collectionViewLayout,indexPath)
        }
        if let f = fixedHeight {
            return CGSize(width: wid, height: f)
        }
        if let f = fixedSize {
            return f
        }
        
        return CGSize(width: wid, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if let f = fixedHeaderHeight {
            return CGSize(width: collectionView.frame.size.width, height: f)
        }
        return CGSize.zero
    }
    
}

class BaseSectionCollectionViewController: BaseCollectionViewController {
    
    var sections = [SectionController]()
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return sections[indexPath.section].viewForSupplementaryElementOfKind!(collectionView,kind,indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return sections[section].collectionView(collectionView,layout:collectionViewLayout,referenceSizeForHeaderInSection:section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = sections[indexPath.section]
        return section.collectionView(collectionView,cellForItemAt:indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sections[indexPath.section].collectionView(collectionView,layout:collectionViewLayout,sizeForItemAt:indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        section.didSelectItemAt?(collectionView, indexPath)
    }
    
    override open func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView?.visibleCells.forEach { (cell) in
            let indexPath = collectionView!.indexPath(for: cell)
            let section = self.sections[indexPath!.section]
            if section.fillCellWidth {
                cell.contentView.snp.remakeConstraints({ (make) in
                    make.width.equalTo(size.width)
                })
                cell.setNeedsLayout()
            }
        }
    }
    
}
