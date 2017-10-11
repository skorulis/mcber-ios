//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension CombinedActivityResult {
    var resourcesAndCredits:[ResourceModel] {
        if self.currency == 0 {
            return resources
        }
        let currency = ResourceModel(quantity: self.currency, resourceId: "currency")
        currency.fill(ref: ReferenceService.instance)
        var array = [currency]
        array.append(contentsOf: resources)
        return array
    }
    
    func resourceAt(indexPath:IndexPath) -> ResourceModel {
        return resourcesAndCredits[indexPath.row]
    }
    
    func resourceCount() -> Int {
        return resourcesAndCredits.count
    }
}

class ActivityResultViewController: BaseSectionCollectionViewController {

    var result:CombinedActivityResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = result.title
        
        collectionView.register(clazz: ResourceCell.self)
        collectionView.register(clazz: ExperienceGainCell.self)
        collectionView.register(clazz: RealmUnlockCell.self)
        collectionView.register(clazz: ItemCell.self)
        collectionView.register(clazz: GemCell.self)
        collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        if let unlock = self.result.realmUnlock {
            let unlockSection = SectionController()
            unlockSection.fixedHeaderHeight = 40
            unlockSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Unlocked Realms")
            unlockSection.cellForItemAt = RealmUnlockCell.curriedDefaultCell(withModel: unlock)
            self.sections.append(unlockSection)
        }
        
        if (result.resources.count > 0) {
            let resourceSection = SectionController()
            resourceSection.simpleNumberOfItemsInSection = result.resourceCount
            resourceSection.cellForItemAt = ResourceCell.curriedDefaultCell(getModel: result.resourceAt(indexPath:))
            resourceSection.fixedHeaderHeight = 40
            resourceSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Resources")
            self.sections.append(resourceSection)
        }
        
        if (xpCount() > 0) {
            let xpSection = SectionController()
            xpSection.simpleNumberOfItemsInSection = xpCount
            xpSection.cellForItemAt = ExperienceGainCell.curriedDefaultCell(getModel: xpAt(indexPath:))
            xpSection.fixedHeaderHeight = 40
            xpSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Experience")
            self.sections.append(xpSection)
        }
        
        if result.items.count > 0 {
            let itemSection = SectionController()
            itemSection.simpleNumberOfItemsInSection = result.itemCount
            itemSection.cellForItemAt = ItemCell.curriedDefaultCell(getModel: result.itemAt(indexPath:))
            /*itemSection.sizeForItemAt = { (collectionView:UICollectionView,layout:UICollectionViewLayout, indexPath:IndexPath) in
             return CGSize(width: collectionView.frame.width, height: 50)
             }*/
            
            itemSection.fixedHeaderHeight = 40
            itemSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Items")
            
            self.sections.append(itemSection)
        }
        
        if result.gems.count > 0 {
            let gemSection = SectionController()
            gemSection.simpleNumberOfItemsInSection = result.gemCount
            gemSection.cellForItemAt = GemCell.curriedDefaultCell(getModel: result.gemAt(indexPath:))

            gemSection.fixedHeaderHeight = 40
            gemSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Gems")
            
            self.sections.append(gemSection)
        }
        
        if result.foundAvatars.count > 0 {
            let monitoredArray = MonitoredArray(array: result.foundAvatars)
            let avatarSection = AvatarCell.defaultArraySection(data: monitoredArray, collectionView: collectionView)
            avatarSection.fixedHeaderHeight = 40
            avatarSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text: "Avatars")
            self.add(section: avatarSection)
        }
        
    }
    
    //MARK: Data access
    
    func xpCount() -> Int {
        return result.experience.count
    }
    
    func xpAt(indexPath:IndexPath) -> ExperienceGainModel {
        return result.experience[indexPath.row]
    }
    
}
