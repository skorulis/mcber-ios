//  Created by Alexander Skorulis on 7/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSelectionViewController: BaseSectionCollectionViewController {

    var didSelectItem: ( (ItemModel) -> () )?
    
    var user:UserModel {
        return self.services.state.user!
    }
    
    var items:[ItemModel] {
        return user.items.array
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Item"
        
        collectionView.register(clazz: ItemCell.self)
        
        let itemAt:(IndexPath) -> (ItemModel?) = {[unowned self] (indexPath) in return self.items[indexPath.row]}
        
        let itemSection = SectionController()
        itemSection.simpleNumberOfItemsInSection = {[unowned self] in return self.items.count}
        itemSection.cellForItemAt = ItemCell.curriedDefaultCell(getModel: itemAt)
        itemSection.sizeForItemAt = ItemCell.curriedCalculateSize(getModel: itemAt)
        itemSection.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let item = itemAt(indexPath)!
            self.didSelectItem?(item)
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(itemSection)
    }

}
