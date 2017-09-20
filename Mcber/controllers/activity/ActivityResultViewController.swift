//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityResultViewController: BaseSectionCollectionViewController {

    var result:ActivityResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Result"
        
        collectionView.register(clazz: ResourceCell.self)
        collectionView.register(clazz: ExperienceGainCell.self)
        collectionView.register(clazz: RealmUnlockCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        if let unlock = self.result.realmUnlock {
            let unlockSection = SectionController()
            unlockSection.fixedHeaderHeight = 40
            unlockSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Unlocked Realms")
            unlockSection.cellForItemAt = RealmUnlockCell.curriedDefaultCell(withModel: unlock)
            self.sections.append(unlockSection)
        }
        
        let resourceSection = SectionController()
        resourceSection.cellForItemAt = ResourceCell.curriedDefaultCell(withModel: result.resource)
        resourceSection.fixedHeaderHeight = 40
        resourceSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Resources")
        
        let xpSection = SectionController()
        xpSection.simpleNumberOfItemsInSection = xpCount
        xpSection.cellForItemAt = ExperienceGainCell.curriedDefaultCell(getModel: xpAt(indexPath:))
        xpSection.fixedHeaderHeight = 40
        xpSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Experience")
        
        
        self.sections.append(resourceSection)
        self.sections.append(xpSection)
    }
    
    //MARK: Data access
    
    func xpCount() -> Int {
        return result.experience.count
    }
    
    func xpAt(indexPath:IndexPath) -> ExperienceGainModel {
        return result.experience[indexPath.row]
    }
    
}
