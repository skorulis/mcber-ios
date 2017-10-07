//  Created by Alexander Skorulis on 7/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class StartSocketGemViewController: BaseStartActivityViewController {

    var selectedGem:ItemGemModel?
    var selectedItem:ItemModel?
    
    let gemSection = SectionController()
    let itemSection = SectionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Socket gem"

        collectionView.register(clazz: ItemCell.self)
        collectionView.register(clazz: GemCell.self)
        
        let gemHeaderVM = ForwardNavigationViewModel(text: "Select Gem")
        let itemHeaderVM = ForwardNavigationViewModel(text: "Select Item")
        let gemAt:(IndexPath) -> (ItemGemModel?) = {[unowned self] (indexPath) in return self.selectedGem}
        let itemAt:(IndexPath) -> (ItemModel?) = {[unowned self] (indexPath) in return self.selectedItem}
        
        gemSection.fixedHeaderHeight = 40
        gemSection.simpleNumberOfItemsInSection = {[unowned self] in return self.selectedGem != nil ? 1 : 0}
        gemSection.viewForSupplementaryElementOfKind = ForwardNavigationHeader.curriedSupplementaryView(withModel: gemHeaderVM,target:self,action: #selector(self.selectGemPressed(sender:)))
        
        gemSection.cellForItemAt = GemCell.curriedDefaultCell(getModel: gemAt)
        gemSection.sizeForItemAt = GemCell.curriedCalculateSize(getModel: gemAt)

        itemSection.fixedHeaderHeight = 40
        itemSection.simpleNumberOfItemsInSection = {[unowned self] in return self.selectedItem != nil ? 1 : 0}
        itemSection.viewForSupplementaryElementOfKind = ForwardNavigationHeader.curriedSupplementaryView(withModel: itemHeaderVM,target:self,action: #selector(self.selectItemPressed(sender:)))
        
        itemSection.cellForItemAt = ItemCell.curriedDefaultCell(getModel: itemAt)
        itemSection.sizeForItemAt = ItemCell.curriedCalculateSize(getModel: itemAt)
        
        
        self.sections.append(gemSection)
        self.sections.append(itemSection)
        self.sections.append(avatarSection)
        self.sections.append(startSection(title: "Start Socketing"))
    }

    override func getEstimate(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return nil
    }
    
    override func startActivity(avatar:AvatarModel) -> Promise<ActivityResponse>? {
        return nil
    }
    
    //MARK: Actions
    
    @objc func selectItemPressed(sender:Any) {
        let vc = ItemSelectionViewController(services: self.services);
        vc.didSelectItem = {[unowned self] (item) in
            self.selectedItem = item
            self.tryUpdateEstimate()
            self.collectionView.reloadData()
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func selectGemPressed(sender:Any) {
        
    }
    
}
