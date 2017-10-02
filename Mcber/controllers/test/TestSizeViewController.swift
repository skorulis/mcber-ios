//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class TestSectionSizeViewController: BaseSectionCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(clazz: TestSizeCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        //self.flowLayout?.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        //self.flowLayout?.headerReferenceSize = UICollectionViewFlowLayoutAutomaticSize
        
        let section = SectionController(fillCellWidth: true, useAutoHeightCells: false)
        section.fixedCellCount = 2
        section.fixedHeaderHeight = 40
        section.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Section 1")
        section.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:TestSizeCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme,fillWidth:true)
            cell.contentView.backgroundColor = UIColor.lightGray
            return cell
        }
        self.sections.append(section)
        
        let section2 = SectionController(fillCellWidth: true, useAutoHeightCells: false)
        section2.fixedCellCount = 3
        section2.fixedHeaderHeight = 40
        section2.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Section 2")
        section2.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:TestSizeCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme,fillWidth:true)
            cell.contentView.backgroundColor = UIColor.lightGray
            return cell
        }
        self.sections.append(section2)
    }
    
}

class TestSizeViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoFillWidth = true

        collectionView.register(clazz: TestSizeCell.self)
        self.flowLayout?.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        self.flowLayout?.itemSize = UICollectionViewFlowLayoutAutomaticSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TestSizeCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: theme,fillWidth:true)
        cell.contentView.backgroundColor = UIColor.lightGray
        return cell
    }

}
