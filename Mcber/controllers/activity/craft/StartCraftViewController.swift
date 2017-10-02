//  Created by Alexander Skorulis on 24/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class StartCraftViewController: BaseStartActivityViewController {

    var selectedItem:ItemBaseTypeRef?
    
    let itemSection = SectionController()
    
    func itemCount() -> Int {
        return self.selectedItem != nil ? 1 : 0
    }
    
    func itemAt(indexPath:IndexPath) -> ItemBaseTypeRef {
        return self.selectedItem!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Craft"
        
        collectionView.register(clazz: BaseItemCell.self)
        
        itemSection.fixedHeaderHeight = 40
        itemSection.fixedHeight = 70
        itemSection.simpleNumberOfItemsInSection = itemCount
        itemSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Item")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectItemPressed(sender:)))
            return header
        }
        itemSection.cellForItemAt = BaseItemCell.curriedDefaultCell(getModel: itemAt(indexPath:))
        
        let startSection = self.startSection(title: "Start Crafting")
        
        sections.append(itemSection)
        sections.append(avatarSection)
        sections.append(startSection)
    }
    
    @objc func selectItemPressed(sender:Any) {
        let vc = ItemTypeSelectionViewController(services: self.services)
        vc.didSelectItem = {[unowned self] item in
            self.selectedItem = item
            self.tryUpdateEstimate()
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func startActivity(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return selectedItem.map({ (item) -> Promise<ActivityResponse> in
            return self.services.activity.craft(avatarId: avatar._id, itemRefId: item.name)
        })
    }
    
    override func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return selectedItem.map({ (item) -> Promise<ActivityResponse> in
            return self.services.api.craft(avatarId: avatar._id, itemRefId: item.name,estimate: true)
        })
    }
    
}
