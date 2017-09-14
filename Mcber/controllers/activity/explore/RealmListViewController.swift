//  Created by Alexander Skorulis on 15/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RealmListViewController: BaseCollectionViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(clazz: RealmCell.self)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.layout.itemSize = CGSize(width: collectionView.frame.size.width, height: 60)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.services.ref.allElements().count
    }
    
    override public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:RealmCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
        let realm = self.services.ref.allRealms()[indexPath.row]
        cell.realm = realm
        return cell
    }

}
