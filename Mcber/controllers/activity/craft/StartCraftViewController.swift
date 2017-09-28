//  Created by Alexander Skorulis on 24/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StartCraftViewController: BaseSectionCollectionViewController {

    var selectedItem:ItemBaseTypeRef?
    var selectedAvatar:AvatarModel?
    
    let avatarSection = SectionController()
    let itemSection = SectionController()
    let startSection = SectionController()
    
    func avatarCount() -> Int {
        return self.selectedAvatar != nil ? 1 : 0
    }
    
    func itemCount() -> Int {
        return self.selectedItem != nil ? 1 : 0
    }
    
    func itemAt(indexPath:IndexPath) -> ItemBaseTypeRef {
        return self.selectedItem!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Craft"
        
        collectionView.register(clazz: AvatarCell.self)
        collectionView.register(clazz: BaseItemCell.self)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        itemSection.fixedHeaderHeight = 40
        itemSection.fixedHeight = 70
        itemSection.simpleNumberOfItemsInSection = itemCount
        itemSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Item")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectItemPressed(sender:)))
            return header
        }
        itemSection.cellForItemAt = BaseItemCell.curriedDefaultCell(getModel: itemAt(indexPath:))
        
        
        avatarSection.fixedHeaderHeight = 40
        avatarSection.simpleNumberOfItemsInSection = avatarCount
        avatarSection.fixedHeight = 120
        avatarSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectAvatarPressed(id:)))
            return header
        }
        avatarSection.cellForItemAt = AvatarCell.curriedDefaultCell(getModel: {[unowned self] (IndexPath)->(AvatarModel) in return self.selectedAvatar! })
        
        startSection.fixedHeaderHeight = 40
        startSection.fixedCellCount = 0
        startSection.fixedHeight = 60
        startSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Craft!")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.startPressed(id:)))
            return header
        }
        
        sections.append(itemSection)
        sections.append(avatarSection)
        sections.append(startSection)
    }
    
    func selectAvatarPressed(id:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar = avatar
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectItemPressed(sender:Any) {
        let vc = ItemTypeSelectionViewController(services: self.services)
        vc.didSelectItem = { item in
            self.selectedItem = item
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func startPressed(id:Any) {
        if let avatar = selectedAvatar, let item = selectedItem {
            _ = self.services.activity.craft(avatar: avatar, itemRef: item).then { [weak self] (response) -> Void in
                self?.clear()
                self?.collectionView.reloadData()
            }
        }
    }
    
    func clear() {
        selectedAvatar = nil
        selectedItem = nil
        self.collectionView.reloadData()
    }
    
}
