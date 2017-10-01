//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class TestSizeViewController: BaseCollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoFillWidth = true

        collectionView.register(clazz: TestSizeCell.self)
        self.flowLayout?.estimatedItemSize = UICollectionViewFlowLayoutAutomaticSize
        self.flowLayout?.itemSize = UICollectionViewFlowLayoutAutomaticSize
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:TestSizeCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: theme,fillWidth:true)
        cell.contentView.backgroundColor = UIColor.lightGray
        print("Layout for \(indexPath.row)")
        return cell
    }

}
