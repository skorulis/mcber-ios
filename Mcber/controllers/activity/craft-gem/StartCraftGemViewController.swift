//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class StartCraftGemViewController: BaseStartActivityViewController {

    var selectedGem: ItemModRef?
    var selectedSkill: SkillRefModel?
    let selectedLevel = StepperCellViewModel(title:"Select Gem Level")
    
    func gemCount() -> Int { return selectedGem != nil ? 1 : 0}
    func skillCount() -> Int { return selectedSkill != nil ? 1 : 0 }
    
    func gemAt(indexPath:IndexPath) -> ItemModRef? { return selectedGem }
    func skillAt(indexPath:IndexPath) -> SkillRefModel? { return selectedSkill }
    
    let gemSection = SectionController()
    let skillSection = SectionController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Craft Gem"
        
        collectionView.register(clazz: BaseGemCell.self)
        collectionView.register(clazz: StepperCountCell.self)
        collectionView.register(clazz: SkillRefCell.self)
        
        let gemHeaderVM = ForwardNavigationViewModel(text: "Select Gem Type")
        
        gemSection.fixedHeaderHeight = 40
        gemSection.simpleNumberOfItemsInSection = gemCount
        gemSection.viewForSupplementaryElementOfKind = ForwardNavigationHeader.curriedSupplementaryView(withModel: gemHeaderVM,target:self,action: #selector(self.selectGemPressed(sender:)))
        
        gemSection.cellForItemAt = BaseGemCell.curriedDefaultCell(getModel: gemAt(indexPath:))
        gemSection.sizeForItemAt = BaseGemCell.curriedCalculateSize(getModel: gemAt(indexPath:))
        
        let skillHeaderVM = ForwardNavigationViewModel(text: "Select Skill")
        skillSection.fixedHeaderHeight = 40
        skillSection.simpleNumberOfItemsInSection = skillCount
        skillSection.viewForSupplementaryElementOfKind = ForwardNavigationHeader.curriedSupplementaryView(withModel: skillHeaderVM,target:self,action: #selector(selectSkillPressed(sender:)))
        skillSection.cellForItemAt = SkillRefCell.curriedDefaultCell(getModel: skillAt(indexPath:))
        
        let levelSection = SectionController()
        levelSection.cellForItemAt = StepperCountCell.curriedDefaultCell(withModel: selectedLevel,changeBlock:levelDidChange(model:))
        levelSection.sizeForItemAt = StepperCountCell.curriedCalculateSize(withModel: selectedLevel)
        
        self.sections.append(gemSection)
        self.sections.append(levelSection)
        self.sections.append(avatarSection)
        self.sections.append(startSection(title: "Start Crafting"))
    }
    
    func levelDidChange(model:StepperCellViewModel) {
        self.tryUpdateEstimate()
    }
    
    @objc func selectGemPressed(sender:Any) {
        let vc = GemTypeSelectionViewController(services: self.services)
        vc.didSelectGem = {[unowned self] gem in
            self.selectedGem = gem
            self.tryUpdateEstimate()
            if self.needsSkill() {
                self.add(section: self.skillSection, after: self.gemSection)
            } else {
                self.remove(section: self.skillSection)
            }
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func selectSkillPressed(sender:Any) {
        let vc = SkillSelectionViewController(services: self.services)
        vc.skills = self.services.ref.allElements() //TODO: Add support for trade skills
        vc.didSelectSkill = {[unowned self] skill in
            self.selectedSkill = skill
            self.tryUpdateEstimate()
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func needsSkill() -> Bool {
        guard let selectedGem = self.selectedGem else {
            return false
        }
        return selectedGem.skillType != .none
    }
    
    func getAPIModel() -> ActivityGemModel? {
        guard let selectedGem = self.selectedGem else {
            return nil
        }
        var elementId:String? = nil
        if self.needsSkill() {
            guard let element = selectedSkill else {
                return nil
            }
            elementId = element.id
        }
        
        return ActivityGemModel(modId: selectedGem.type, level: selectedLevel.value, elementId: elementId)
    }
    
    override func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return self.getAPIModel().map { (gem) -> Promise<ActivityResponse> in
            return self.services.api.craftGem(avatarId: avatar._id, gem: gem,estimate: true)
        }
    }
    
    override func startActivity(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return self.getAPIModel().map { (gem) -> Promise<ActivityResponse> in
            return self.services.activity.craftGem(avatarId: avatar._id, gem: gem)
        }
    }

}
