//  Created by Alexander Skorulis on 4/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class SkillSelectionViewController: BaseSectionCollectionViewController {

    var didSelectSkill: ((SkillRefModel) -> ())?
    
    var skills:[SkillRefModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Select Skill"
        
        self.collectionView.register(clazz: SkillRefCell.self)
        
        let getModel:(IndexPath) -> SkillRefModel = {[unowned self] indexPath in
            return self.skills[indexPath.row]
        }
        
        let section = SectionController()
        section.fixedCellCount = skills.count
        section.cellForItemAt = SkillRefCell.curriedDefaultCell(getModel: getModel)
        section.didSelectItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            self.didSelectSkill?(self.skills[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
        
        self.sections.append(section)
    }

}
