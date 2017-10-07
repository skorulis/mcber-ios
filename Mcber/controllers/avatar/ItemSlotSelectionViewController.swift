//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSlotSelectionViewController: BaseSectionCollectionViewController {
    
    var didSelectItem: ( (ItemModel?,ItemSlotRef) -> () )?
    
    var slot:ItemSlotRef!
    var avatar:AvatarModel!
    var user:UserModel {
        return self.services.state.user!
    }
    
    var items:[ItemModel] {
        return user.itemsForSlot(slot: slot)
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
            let item = itemAt(indexPath)
            self.didSelectItem?(item,self.slot)
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(itemSection)
    }

}
