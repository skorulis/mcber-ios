//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarEquipmentViewController: BaseSectionCollectionViewController {

    let avatar:MonitoredObject<AvatarModel>
    
    init(services: ServiceLocator,avatar:AvatarModel) {
        self.avatar = services.state.monitor(avatar: avatar)
        super.init(services: services)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var slots: [ItemSlotRef] {
        return self.services.ref.items!.itemSlots
    }
    
    func itemCount(slot:ItemSlotRef) -> Int {
        let item = avatar.value.itemAt(slot: slot)
        return item != nil ? 1 : 0
    }
    
    func itemAt(indexPath:IndexPath) -> ItemModel {
        let slot = slots[indexPath.section]
        return avatar.value.itemAt(slot: slot)! //Force get
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Equipment"
        self.avatar.valueDidChange = { old,new in
            print("Equip change")
            self.collectionView.reloadData()
        }
        
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
        let vm = ItemSlotViewModel(slot: slot)
        section.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ItemSlotSelectionHeader.curriedSupplementaryView(withModel: vm)(collectionView,kind,indexPath)
            header.selectBlock = { [unowned self] slot in
                let vc = ItemSelectionViewController(services: self.services)
                vc.avatar = self.avatar.value
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
        _ = self.services.avatar.assignItem(item: item, slot: slot, avatar: self.avatar.value).then { response -> Void in
            self.collectionView.reloadData()
        }
    }

}
