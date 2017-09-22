//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSlotSelectionHeader: ForwardNavigationHeader, SimpleModelCell {

    typealias ModelType = ItemSlotRef
    
    var selectBlock: ( (ItemSlotRef) -> () )?
    
    var model: ItemSlotRef? {
        didSet {
            self.label.text = model?.name
        }
    }
    
    override func buildView(theme: ThemeService) {
        super.buildView(theme: theme)
        self.addTapTarget(target: self, action: #selector(pressed(sender:)))
    }
    
    func pressed(sender:Any) {
        selectBlock?(model!)
    }
    

}
