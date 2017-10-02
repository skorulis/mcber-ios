//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class StartExploreViewController: BaseStartActivityViewController {

    var selectedRealm:RealmModel?
    let realmSection = SectionController()
    
    func realmCount() -> Int {
        return self.selectedRealm != nil ? 1 : 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Explore"
        
        collectionView.register(clazz: RealmCell.self)
        
        realmSection.fixedHeaderHeight = 40
        realmSection.fixedCellCount = 0
        realmSection.fixedHeight = 70
        realmSection.simpleNumberOfItemsInSection = realmCount
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
        
        let startSection = self.startSection(title: "Start Exploring!")
        
        sections.append(realmSection)
        sections.append(avatarSection)
        sections.append(startSection)
    }
    
    @objc func selectRealmPressed(id:Any) {
        let vc = RealmListViewController(services: self.services)
        vc.didSelectRealm = {[unowned self] (realmListVC:RealmListViewController,realm:RealmModel) in
            realmListVC.navigationController?.popViewController(animated: true)
            self.selectedRealm = realm
            self.tryUpdateEstimate()
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func startActivity(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return selectedRealm.map({ (realm) -> Promise<ActivityResponse> in
            return self.services.activity.explore(avatarId: avatar._id, realm: realm)
        })
    }
    
    override func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return selectedRealm.map({ (realm) -> Promise<ActivityResponse> in
            return self.services.api.explore(avatarId: avatar._id, realm: realm, estimate: true)
        })
    }
    
}
