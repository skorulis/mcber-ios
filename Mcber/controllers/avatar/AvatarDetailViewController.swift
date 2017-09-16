//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarDetailViewController: BaseSectionCollectionViewController {

    var avatar:AvatarModel!
    
    var elements:[SkillProgressModel] {
        return avatar.skills.elements
    }
    
    var trades:[SkillProgressModel] {
        return avatar.skills.trades
    }
    
    func elementAt(indexPath:IndexPath) -> (SkillProgressModel,SkillModel) {
        return self.services.ref.filledSkill(progress: self.elements[indexPath.row])
    }
    
    func tradeAt(indexPath:IndexPath) -> (SkillProgressModel,SkillModel) {
        return self.services.ref.filledSkill(progress: self.trades[indexPath.row])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Avatar"

        self.collectionView.register(clazz: AvatarCell.self)
        self.collectionView.register(clazz: AvatarSkillCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let topSection = SectionController()
        topSection.fixedHeight = 90
        topSection.cellForItemAt = { [unowned self] (collectionView:UICollectionView,indexPath:IndexPath) in
            let cell:AvatarCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: self.theme)
            cell.model = self.avatar
            return cell
        }
        
        let elementSkillsSection = skillSection(title: "Elemental Skills", count: elements.count, skillAt: elementAt(indexPath:))
        let tradeSkillsSection = skillSection(title: "Trade Skills", count: trades.count, skillAt: tradeAt(indexPath:))
        
        self.sections.append(topSection)
        self.sections.append(elementSkillsSection)
        self.sections.append(tradeSkillsSection)
    }
    
    func skillSection(title:String,count:Int,skillAt: @escaping (IndexPath) -> (SkillProgressModel,SkillModel)) -> SectionController {
        let skillsSection = SectionController()
        skillsSection.fixedCellCount = count
        skillsSection.fixedHeight = 90
        skillsSection.cellForItemAt = AvatarSkillCell.curriedDefaultCell(getModel: skillAt)
        skillsSection.fixedHeaderHeight = 40
        skillsSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text:title)
        return skillsSection
    }

}
