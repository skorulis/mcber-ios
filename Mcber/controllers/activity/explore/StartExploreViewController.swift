//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StartExploreViewController: BaseSectionCollectionViewController {

    var selectedRealm:RealmModel?
    var selectedAvatar:AvatarModel?
    var estimatedActivity:ActivityModel?
    
    let realmSection = SectionController()
    let avatarSection = SectionController()
    let startSection = SectionController()
    
    func isReady() -> Bool {
        return selectedRealm != nil && selectedAvatar != nil
    }
    
    func estimate(indexPath:IndexPath) -> ActivityModel? {
        return estimatedActivity
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Explore"
        
        collectionView.register(clazz: RealmCell.self)
        collectionView.register(clazz: AvatarCell.self)
        collectionView.register(clazz: ActivityEstimateCell.self)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionFooter)
        
        realmSection.fixedHeaderHeight = 40
        realmSection.fixedCellCount = 0
        realmSection.fixedHeight = 70
        realmSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Realm")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectRealmPressed(id:)))
            return header
        }
        
        realmSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:RealmCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.realm = self.selectedRealm!
            cell.selectedLevel = self.selectedRealm!.level
            return cell;
        }
        
        avatarSection.fixedHeaderHeight = 40
        avatarSection.fixedCellCount = 0
        avatarSection.fixedHeight = 120
        avatarSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectAvatarPressed(id:)))
            return header
        }
        avatarSection.cellForItemAt = AvatarCell.curriedDefaultCell(getModel: {[unowned self] (IndexPath)->(AvatarModel) in return self.selectedAvatar! })
            
        startSection.fixedFooterHeight = 40
        startSection.fixedCellCount = 0
        startSection.fixedHeight = 60
        startSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            if (kind == UICollectionElementKindSectionHeader) {
                return SectionHeaderView.curriedHeaderFunc(theme: ThemeService.theme, text: "Preview")(collectionView,kind,indexPath)
            }
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Start Exploring!")(collectionView,kind,indexPath)
            header.textColor = self.isReady() ? self.theme.color.defaultText : self.theme.color.disabledText
            header.addTapTarget(target: self, action: #selector(self.startPressed(id:)))
            return header
        }
        startSection.cellForItemAt = ActivityEstimateCell.curriedDefaultCell(getModel: self.estimate(indexPath:))
        
        sections.append(realmSection)
        sections.append(avatarSection)
        sections.append(startSection)
    }
    
    func update() {
        realmSection.fixedCellCount = selectedRealm != nil ? 1 : 0
        avatarSection.fixedCellCount = selectedAvatar != nil ? 1 : 0
        startSection.fixedCellCount = self.isReady() ? 1 : 0
        startSection.fixedHeaderHeight = self.isReady() ? 40 : 0
        if let avatar = selectedAvatar, let realm = selectedRealm {
            let promise = self.services.api.explore(avatarId: avatar._id, realm: realm, estimate: true)
            _ = promise.then { [weak self] (response) -> Void in
                self?.estimatedActivity = response.activity
                self?.collectionView.reloadData()
            }
        }
        self.collectionView.reloadData()
    }
    
    @objc func selectRealmPressed(id:Any) {
        let vc = RealmListViewController(services: self.services)
        vc.didSelectRealm = {[unowned self] (realmListVC:RealmListViewController,realm:RealmModel) in
            realmListVC.navigationController?.popViewController(animated: true)
            self.selectedRealm = realm
            self.update()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func selectAvatarPressed(id:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar = avatar
            self.update()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func clear() {
        selectedRealm = nil
        selectedAvatar = nil
        estimatedActivity = nil
        self.update()
    }
    
    @objc func startPressed(id:Any) {
        if let avatar = selectedAvatar, let realm = selectedRealm {
            _ = self.services.activity.explore(avatarId: avatar._id, realm: realm).then { [weak self] (response) -> Void in
                self?.clear()
                self?.navigationController?.popViewController(animated: true)
            }.catch { [weak self] error in
                self?.show(error: error)
            }
        }
    }
}
