//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ResourceCell: BasicKeyValueCell, SimpleModelCell {

    typealias ModelType = (ResourceModel, ResourceRefModel)
    var model: (ResourceModel, ResourceRefModel)? {
        didSet {
            if let resource = model?.0, let ref = model?.1 {
                nameLabel.text = ref.name
                valueLabel.text = "+\(resource.quantity)"
            }
            
        }
    }
    
}
