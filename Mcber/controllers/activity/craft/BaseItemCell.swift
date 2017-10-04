//  Created by Alexander Skorulis on 24/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class BaseItemCell: BasicKeyValueCell, SimpleModelCell {
    
    typealias ModelType = ItemBaseTypeRef
    var model: ItemBaseTypeRef? {
        didSet {
            self.nameLabel.text = model?.id
        }
    }
    
}
