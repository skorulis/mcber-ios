//  Created by Alexander Skorulis on 24/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StartCraftViewController: BaseSectionCollectionViewController {

    var selectedItem:ItemBaseTypeRef?
    var selectedAvatar:AvatarModel?
    var estimatedActivity:ActivityModel?
    
    let avatarSection = SectionController()
    let itemSection = SectionController()
    
    func estimate(indexPath:IndexPath) -> ActivityViewModel? {
        return estimatedActivity.map { ActivityViewModel(activity:$0,user:self.services.state.user!,theme:self.theme) }
    }
    
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
        collectionView.register(clazz: ActivityEstimateCell.self)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionFooter)
        
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
        
        let startSection = StartActivityHelpers.startSection(title: "Start Crafting", getEstimate: estimate(indexPath:), startTarget: self, startAction: #selector(startPressed(id:)))
        
        sections.append(itemSection)
        sections.append(avatarSection)
        sections.append(startSection)
    }
    
    func tryUpdateEstimate() {
        if let avatar = selectedAvatar, let item = selectedItem {
            let promise = self.services.api.craft(avatarId: avatar._id, itemRefId: item.name,estimate: true)
            _ = promise.then { [weak self] (response) -> Void in
                self?.estimatedActivity = response.activity
                self?.collectionView.reloadData()
            }
        }
    }
    
    @objc func selectAvatarPressed(id:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar = avatar
            self.tryUpdateEstimate()
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func startPressed(id:Any) {
        if let avatar = selectedAvatar, let item = selectedItem {
            _ = self.services.activity.craft(avatarId: avatar._id, itemRefId: item.name).then { [weak self] (response) -> Void in
                self?.clear()
                self?.navigationController?.popViewController(animated: true)
                }.catch { [weak self] error in
                    self?.show(error: error)
                }
        }
    }
    
    func clear() {
        selectedAvatar = nil
        selectedItem = nil
        self.collectionView.reloadData()
    }
    
}
