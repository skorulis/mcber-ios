//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class TestSizeViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(clazz: TestSizeCell.self)
        layout.estimatedItemSize = CGSize(width: 0, height: 0)
        //layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TestSizeCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: theme)
        return cell
    }

}
