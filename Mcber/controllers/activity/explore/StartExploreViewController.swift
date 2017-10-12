//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class StartExploreViewController: BaseStartActivityViewController {

    var selectedRealm = OptionalMonitoredObject<RealmModel>(element:nil)
    let realmSection = SectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Explore"
        
        collectionView.register(clazz: RealmCell.self)
        
        realmSection.fixedHeaderHeight = 40
        realmSection.fixedCellCount = 0
        realmSection.fixedHeight = 70
        realmSection.simpleNumberOfItemsInSection = selectedRealm.elementCount
        realmSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Realm")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectRealmPressed(id:)))
            return header
        }
        
        realmSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:RealmCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.realm = self.selectedRealm.object!
            cell.selectedLevel = self.selectedRealm.object!.level
            cell.didSelectLevel = { [unowned self] (level:Int) in
                let currentRealm = self.selectedRealm.object!
                let newRealm = RealmModel(elementId: currentRealm.elementId, level: level, maximumLevel: currentRealm.maximumLevel)
                self.didSelectRealm(realm: newRealm)
            }
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
            self.didSelectRealm(realm: realm)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectRealm(realm:RealmModel) {
        self.selectedRealm.object = realm
        self.tryUpdateEstimate()
        self.collectionView.reloadData()
    }
    
    override func startActivity(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return selectedRealm.object.map({ (realm) -> Promise<ActivityResponse> in
            return self.services.activity.explore(avatarId: avatar._id, realm: realm)
        })
    }
    
    override func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return selectedRealm.object.map({ (realm) -> Promise<ActivityResponse> in
            return self.services.api.explore(avatarId: avatar._id, realm: realm, estimate: true)
        })
    }
    
}
