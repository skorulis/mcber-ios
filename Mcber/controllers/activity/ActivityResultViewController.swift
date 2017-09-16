//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityResultViewController: BaseSectionCollectionViewController {

    var result:ActivityResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Result"
        
        collectionView.register(clazz: ResourceCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let resourceModel = self.services.ref.filledResource(resource: result.resource)
        
        let resourceSection = SectionController()
        resourceSection.cellForItemAt = ResourceCell.curriedDefaultCell(withModel: resourceModel)
        resourceSection.fixedHeaderHeight = 40
        resourceSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Resources")
        
        self.sections.append(resourceSection)
    }
    
}
