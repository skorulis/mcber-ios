//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemSelectionViewController: BaseSectionCollectionViewController {
    
    var slot:ItemSlotRef!
    var avatar:AvatarModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Item"
    }

}
