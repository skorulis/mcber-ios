//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StartExploreViewController: BaseSectionCollectionViewController {

    var selectedRealm:RealmModel?
    var selectedAvatar:AvatarModel?
    let realmSection = SectionController()
    let avatarSection = SectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(clazz: RealmCell.self)
        collectionView.register(clazz: AvatarCell.self)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        
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
            return cell;
        }
        
        sections.append(realmSection)
        
        
        avatarSection.fixedHeaderHeight = 40
        avatarSection.fixedCellCount = 0
        avatarSection.fixedHeight = 60
        avatarSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectAvatarPressed(id:)))
            return header
        }
        avatarSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:AvatarCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = self.selectedAvatar
            return cell
        }
        
        sections.append(avatarSection)
    }
    
    func update() {
        realmSection.fixedCellCount = selectedRealm != nil ? 1 : 0
        avatarSection.fixedCellCount = selectedAvatar != nil ? 1 : 0
        self.collectionView.reloadData()
    }
    
    func selectRealmPressed(id:Any) {
        let vc = RealmListViewController(services: self.services)
        vc.didSelectRealm = {[unowned self] (realmListVC:RealmListViewController,realm:RealmModel) in
            realmListVC.navigationController?.popViewController(animated: true)
            self.selectedRealm = realm
            self.update()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func selectAvatarPressed(id:Any) {
        let vc = AvatarListViewController(services: self.services)
        vc.didSelectAvatar = {[unowned self] (vc:AvatarListViewController,avatar:AvatarModel) in
            vc.navigationController?.popViewController(animated: true)
            self.selectedAvatar = avatar
            self.update()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
