//  Created by Alexander Skorulis on 4/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class SkillRefCell: BasicKeyValueCell, SimpleModelCell {
    
    typealias ModelType = SkillRefModel
    var model: SkillRefModel? {
        didSet {
            self.nameLabel.text = model?.name
        }
    }
}
