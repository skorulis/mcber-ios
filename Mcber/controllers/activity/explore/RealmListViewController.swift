//  Created by Alexander Skorulis on 15/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RealmListViewController: BaseCollectionViewController {

    var didSelectRealm: ((RealmListViewController,RealmModel) -> () )?
    var realms:[RealmModel] {
        return self.services.state.user!.realms
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.register(clazz: RealmCell.self)
    }
    
    func realmAt(indexPath:IndexPath) -> RealmModel {
        return self.realms[indexPath.row]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout.itemSize = CGSize(width: collectionView.frame.size.width, height: 70)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.ref.allElements().count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:RealmCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
        cell.realm = realmAt(indexPath: indexPath)
        cell.didSelectLevel = { [unowned self] (level:Int) in
            self.didSelectRealm?(self,self.realmAt(indexPath: indexPath))
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectRealm?(self,realmAt(indexPath: indexPath))
    }

}
