//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarDetailViewController: BaseSectionCollectionViewController {

    var avatar:MonitoredObject<AvatarModel>
    
    init(services: ServiceLocator,avatar:AvatarModel) {
        self.avatar = services.state.monitor(avatar: avatar)
        super.init(services: services)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var elements:[SkillProgressModel] {
        return avatar.value.skills.filter { $0.ref.type == .element }
    }
    
    var trades:[SkillProgressModel] {
        return avatar.value.skills.filter { $0.ref.type == .trade }
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
        
        self.collectionView.register(clazz: AvatarSkillCell.self)
        self.collectionView.register(clazz: SectionHeaderView.self, forKind: UICollectionElementKindSectionHeader)
        collectionView.register(clazz: ForwardNavigationHeader.self, forKind: UICollectionElementKindSectionHeader)
        
        let avatarViewModel:MonitoredArrayView<AvatarViewModel,AvatarModel> = avatar.map { AvatarViewModel(avatar:$0) }
        avatarViewModel.observers.add(object: self) { _ in
            self.collectionView.reloadData()
        }
        
        let topSection = AvatarCell.defaultArraySection(data: avatarViewModel, collectionView: collectionView)
        
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
    
    @objc func equipmentPressed(sender:Any) {
        let vc = AvatarEquipmentViewController(services: self.services,avatar:self.avatar.value)
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
