//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarDetailViewController: BaseSectionCollectionViewController {

    var avatar:AvatarModel!
    
    var elements:[SkillProgressModel] {
        return avatar.skills.filter { $0.ref.type == .element }
    }
    
    var trades:[SkillProgressModel] {
        return avatar.skills.filter { $0.ref.type == .trade }
    }
    
    func elementAt(indexPath:IndexPath) -> SkillProgressModel {
        return self.elements[indexPath.row]
    }
    
    func tradeAt(indexPath:IndexPath) -> SkillProgressModel {
        return self.trades[indexPath.row]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Avatar"

        self.collectionView.register(clazz: AvatarCell.self)
        self.collectionView.register(clazz: AvatarSkillCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        let topSection = SectionController()
        topSection.fixedHeight = 120
        topSection.cellForItemAt = AvatarCell.curriedDefaultCell(withModel: self.avatar)
        
        let itemSection = SectionController()
        itemSection.fixedHeaderHeight = 40
        itemSection.fixedCellCount = 0
        itemSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Equipment")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.equipmentPressed(sender:)))
            return header
        }
        
        
        let elementSkillsSection = skillSection(title: "Elemental Skills", count: elements.count, skillAt: elementAt(indexPath:))
        let tradeSkillsSection = skillSection(title: "Trade Skills", count: trades.count, skillAt: tradeAt(indexPath:))
        
        self.sections.append(topSection)
        self.sections.append(itemSection)
        self.sections.append(elementSkillsSection)
        self.sections.append(tradeSkillsSection)
    }
    
    func equipmentPressed(sender:Any) {
        let vc = AvatarEquipmentViewController(services: self.services)
        vc.avatar = self.avatar
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func skillSection(title:String,count:Int,skillAt: @escaping (IndexPath) -> SkillProgressModel) -> SectionController {
        let skillsSection = SectionController()
        skillsSection.fixedCellCount = count
        skillsSection.fixedHeight = 90
        skillsSection.cellForItemAt = AvatarSkillCell.curriedDefaultCell(getModel: skillAt)
        skillsSection.fixedHeaderHeight = 40
        skillsSection.viewForSupplementaryElementOfKind = SectionHeaderView.curriedHeaderFunc(theme: self.theme, text:title)
        return skillsSection
    }

}
