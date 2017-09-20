//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ResourceCell: BasicKeyValueCell, SimpleModelCell {

    typealias ModelType = ResourceModel
    var model: ResourceModel? {
        didSet {
            guard let m = model else { return }
            nameLabel.text = m.refModel.name
            valueLabel.text = "+\(m.quantity)"
        }
    }
    
}
