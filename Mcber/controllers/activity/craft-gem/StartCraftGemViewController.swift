//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class StartCraftGemViewController: BaseStartActivityViewController {

    var selectedGem: ItemModRef?
    var selectedElement: SkillRefModel?
    let selectedLevel = StepperCellViewModel(title:"Select Gem Level")
    
    func gemCount() -> Int { return selectedGem != nil ? 1 : 0}
    
    func gemAt(indexPath:IndexPath) -> ItemModRef? { return selectedGem }
    
    //Choose element (if appropriate)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Craft Gem"
        
        collectionView.register(clazz: BaseGemCell.self)
        collectionView.register(clazz: StepperCountCell.self)
        
        let gemSection = SectionController()
        gemSection.fixedHeaderHeight = 40
        gemSection.simpleNumberOfItemsInSection = gemCount
        gemSection.viewForSupplementaryElementOfKind = { [unowned self] (collectionView:UICollectionView,kind:String,indexPath:IndexPath) in
            let header = ForwardNavigationHeader.curriedDefaultHeader(text: "Select Gem Type")(collectionView,kind,indexPath)
            header.addTapTarget(target: self, action: #selector(self.selectGemPressed(sender:)))
            return header
        }
        gemSection.cellForItemAt = BaseGemCell.curriedDefaultCell(getModel: gemAt(indexPath:))
        gemSection.sizeForItemAt = BaseGemCell.curriedCalculateSize(getModel: gemAt(indexPath:))
        
        let elementSection = SectionController()
        
        
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
            self.collectionView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        guard let selectedGem = self.selectedGem else {
            return nil
        }
        var elementId:String? = nil
        if selectedGem.skillType != .none {
            guard let element = selectedElement else {
                return nil
            }
            elementId = element.id
        }
        
        let gem = ActivityGemModel(modId: selectedGem.type, level: selectedLevel.value, elementId: elementId)
        
        return self.services.api.craftGem(avatarId: avatar._id, gem: gem,estimate: true)
    }

}
