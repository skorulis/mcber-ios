//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSlotViewModel : ForwardNavigationViewModel {
    
    let slot:ItemSlotRef
    
    init(slot:ItemSlotRef) {
        self.slot = slot
        super.init(text: slot.name)
    }
}

class ItemSlotSelectionHeader: ForwardNavigationHeader {
    
    var selectBlock: ( (ItemSlotRef) -> () )?
    
    override func buildView(theme: ThemeService) {
        super.buildView(theme: theme)
        self.addTapTarget(target: self, action: #selector(pressed(sender:)))
    }
    
    @objc func pressed(sender:Any) {
        if let itemModel = self.model as? ItemSlotViewModel {
            selectBlock?(itemModel.slot)
        }
        
    }
    

}
