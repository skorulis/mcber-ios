//  Created by Alexander Skorulis on 7/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSelectionViewController: BaseSectionCollectionViewController {

    var didSelectItem: ( (ItemModel) -> () )?
    
    var user:UserModel {
        return self.services.state.user!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Item"
        let items = self.services.state.monitoredItems
        let itemSection = ItemCell.defaultArraySection(data: items,collectionView: collectionView)
        itemSection.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let item = items.elementAt(indexPath: indexPath)
            self.didSelectItem?(item)
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(itemSection)
    }

}
