//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarEquipmentViewController: BaseSectionCollectionViewController {

    var avatar:AvatarModel!
    
    var slots: [ItemSlotRef] {
        return self.services.ref.items!.itemSlots
    }
    
    func itemCount(slot:ItemSlotRef) -> Int {
        let item = avatar.itemAt(slot: slot)
        return item != nil ? 1 : 0
    }
    
    func itemAt(indexPath:IndexPath) -> ItemModel {
        let slot = slots[indexPath.section]
        return avatar.itemAt(slot: slot)! //Force get
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Equipment"
        
        collectionView.register(clazz: ItemCell.self)
        collectionView.register(clazz: ItemSlotSelectionHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        for slot in self.slots {
            let section = makeSection(slot: slot)
            self.sections.append(section)
        }
        
    }
    
    func makeSection(slot:ItemSlotRef) -> SectionController {
        let section = SectionController()
        section.fixedHeaderHeight = 40
        section.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ItemSlotSelectionHeader.curriedSupplementaryView(withModel: slot)(collectionView,kind,indexPath)
            header.selectBlock = { [unowned self] slot in
                let vc = ItemSelectionViewController(services: self.services)
                vc.avatar = self.avatar
                vc.slot = slot
                vc.didSelectItem = self.didSelectItem(item:slot:)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return header
        }
        
        section.numberOfItemsInSection = {[unowned self] (c:UICollectionView,s:Int) in
            return self.itemCount(slot: slot)
        }
        section.cellForItemAt = ItemCell.curriedDefaultCell(getModel: itemAt(indexPath:))
        
        return section
    }
    
    func didSelectItem(item:ItemModel?,slot:ItemSlotRef) {
        _ = self.services.avatar.assignItem(item: item, slot: slot, avatar: self.avatar).then { response -> Void in
            self.collectionView.reloadData()
        }
    }

}
