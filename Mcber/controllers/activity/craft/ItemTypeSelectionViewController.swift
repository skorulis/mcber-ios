//  Created by Alexander Skorulis on 24/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemTypeSelectionViewController: BaseSectionCollectionViewController {
    
    var didSelectItem: ((ItemBaseTypeRef) -> ())?
    
    func itemCount() -> Int {
        return self.services.ref.allItems().count
    }
    
    func itemAt(indexPath:IndexPath) -> ItemBaseTypeRef {
        return self.services.ref.allItems()[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(clazz: BaseItemCell.self)
        
        let section = SectionController()
        section.simpleNumberOfItemsInSection = itemCount
        section.cellForItemAt = BaseItemCell.curriedDefaultCell(getModel: itemAt(indexPath:))
        section.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            self.didSelectItem?(self.itemAt(indexPath: indexPath))
            self.navigationController?.popViewController(animated: true)
        }
        
        sections.append(section)
        
    }
}
