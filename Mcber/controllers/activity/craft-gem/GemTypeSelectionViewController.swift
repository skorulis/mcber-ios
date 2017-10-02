//  Created by Alexander Skorulis on 3/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class GemTypeSelectionViewController: BaseSectionCollectionViewController {

    var didSelectGem: ((ItemModRef) -> ())?
    
    func gemTypeCount() -> Int {
        return self.services.ref.allGems().count
    }
    
    func gemAt(indexPath:IndexPath) -> ItemModRef {
        return self.services.ref.allGems()[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.register(clazz: BaseGemCell.self)
        
        let gemSection = SectionController()
        gemSection.simpleNumberOfItemsInSection = gemTypeCount
        gemSection.cellForItemAt = BaseGemCell.curriedDefaultCell(getModel: gemAt(indexPath:))
        gemSection.sizeForItemAt = BaseGemCell.curriedCalculateSize(getModel: gemAt(indexPath:))
        gemSection.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            self.didSelectGem?(self.gemAt(indexPath: indexPath))
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(gemSection)
    }

}
