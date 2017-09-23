//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSelectionViewController: BaseSectionCollectionViewController {
    
    var didSelectItem: ( (ItemModel?,ItemSlotRef) -> () )?
    
    var slot:ItemSlotRef!
    var avatar:AvatarModel!
    var user:UserModel {
        return self.services.state.user!
    }
    
    var items:[ItemModel] {
        return user.itemsForSlot(slot: slot)
    }
    
    func itemCount() -> Int {
        return items.count
    }
    
    func itemAt(indexPath:IndexPath) -> ItemModel {
        return items[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Item"
        
        collectionView.register(clazz: ItemCell.self)
        
        let itemSection = SectionController()
        itemSection.simpleNumberOfItemsInSection = itemCount
        itemSection.cellForItemAt = ItemCell.curriedDefaultCell(getModel: itemAt(indexPath:))
        itemSection.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let item = self.itemAt(indexPath: indexPath)
            self.didSelectItem?(item,self.slot)
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(itemSection)
    }

}
