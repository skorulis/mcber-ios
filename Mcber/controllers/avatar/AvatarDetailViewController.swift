//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarDetailViewController: BaseSectionCollectionViewController {

    var avatar:AvatarModel!
    
    var joinedSkills:[JoinedSkill] {
        return avatar.skills.map { self.services.ref.filledSkill(progress:$0) }
    }
    
    var elements:[JoinedSkill] {
        return joinedSkills.filter { $0.ref.type == .element }
    }
    
    var trades:[JoinedSkill] {
        return joinedSkills.filter { $0.ref.type == .trade }
    }
    
    func elementAt(indexPath:IndexPath) -> JoinedSkill {
        return self.elements[indexPath.row]
    }
    
    func tradeAt(indexPath:IndexPath) -> JoinedSkill {
        return self.trades[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Avatar"

        self.collectionView.register(clazz: AvatarCell.self)
        self.collectionView.register(clazz: AvatarSkillCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        
        let topSection = SectionController()
        topSection.fixedHeight = 120
        topSection.cellForItemAt = AvatarCell.curriedDefaultCell(withModel: self.avatar)
        
        let elementSkillsSection = skillSection(title: "Elemental Skills", count: elements.count, skillAt: elementAt(indexPath:))
        let tradeSkillsSection = skillSection(title: "Trade Skills", count: trades.count, skillAt: tradeAt(indexPath:))
        
        self.sections.append(topSection)
        self.sections.append(elementSkillsSection)
        self.sections.append(tradeSkillsSection)
    }
    
    func skillSection(title:String,count:Int,skillAt: @escaping (IndexPath) -> JoinedSkill) -> SectionController {
        let skillsSection = SectionController()
        skillsSection.fixedCellCount = count
        skillsSection.fixedHeight = 90
        skillsSection.cellForItemAt = AvatarSkillCell.curriedDefaultCell(getModel: skillAt)
        skillsSection.fixedHeaderHeight = 40
        skillsSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text:title)
        return skillsSection
    }

}
