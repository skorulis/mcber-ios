//  Created by Alexander Skorulis on 7/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class GemSelectionViewController: BaseSectionCollectionViewController {

    var didSelectGem: ( (ItemGemModel) -> () )?
    
    var user:UserModel {
        return self.services.state.user!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Select Gem"
        let gems = self.services.state.monitoredGems
        let section = GemCell.defaultArraySection(data: gems,collectionView: collectionView)
        section.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let gem = gems.elementAt(indexPath: indexPath)
            self.didSelectGem?(gem)
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(section)
    }

}
