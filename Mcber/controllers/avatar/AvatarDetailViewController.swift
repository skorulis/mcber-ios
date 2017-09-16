//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarDetailViewController: BaseSectionCollectionViewController {

    var avatar:AvatarModel!
    
    var elements:[SkillProgressModel] {
        return avatar.skills.elements
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Avatar"

        self.collectionView.register(clazz: AvatarCell.self)
        self.collectionView.register(clazz: AvatarSkillCell.self)
        
        let topSection = SectionController()
        topSection.fixedHeight = 90
        topSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:AvatarCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = self.avatar
            return cell
        }
        
        let skillsSection = SectionController()
        skillsSection.fixedCellCount = elements.count
        skillsSection.fixedHeight = 90
        skillsSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:AvatarSkillCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            let progress = self.elements[indexPath.row]
            let skill = self.services.ref.element(progress.elementId)
            cell.model = (progress,skill)
            return cell
        }
        
        self.sections.append(topSection)
        self.sections.append(skillsSection)
    }

}
