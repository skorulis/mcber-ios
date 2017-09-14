//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class StartExploreViewController: BaseSectionCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(clazz: RealmCell.self)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        let realmSection = SectionController()
        realmSection.fixedHeaderHeight = 40
        realmSection.fixedCellCount = 0
        realmSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Realm")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectRealmPressed(id:)))
            return header
        }
        
        realmSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:RealmCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            return cell;
        }
        
        sections.append(realmSection)
        
        let avatarSection = SectionController()
        avatarSection.fixedHeaderHeight = 40
        avatarSection.fixedCellCount = 0
        avatarSection.viewForSupplementaryElementOfKind = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Avatar")
        
        sections.append(avatarSection)
        
    }
    
    func selectRealmPressed(id:Any) {
        let vc = RealmListViewController(services: self.services)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
