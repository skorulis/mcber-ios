//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class RandomBattleViewController: BaseInstantActivityViewController {

    var selectedRealm = OptionalMonitoredObject<RealmModel>(element:nil)
    let realmSection = SectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Random Battle"
        
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
            return cell;
        }
        
        let startSection = self.startSection(title: "Battle")
        
        self.add(section: realmSection)
        self.add(section:avatarSection)
        self.add(section: startSection)
    }
    
    //MARK: Overrides
    
    override func isReady() -> Bool {
        return super.isReady() && selectedRealm.object != nil
    }
    
    override func performActivity(avatar:AvatarModel) -> Promise<ActivityCompleteResponse>? {
        return self.services.activity.battle(avatar: avatar, realm: self.selectedRealm.object!)
    }
    
    //MARK: Actions
    
    @objc func selectRealmPressed(id:Any) {
        let vc = RealmListViewController(services: self.services)
        vc.didSelectRealm = {[unowned self] (realmListVC:RealmListViewController,realm:RealmModel) in
            realmListVC.navigationController?.popViewController(animated: true)
            self.selectedRealm.object = realm
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    

}
