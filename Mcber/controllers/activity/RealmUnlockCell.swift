//  Created by Alexander Skorulis on 17/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RealmUnlockCell: BasicKeyValueCell, SimpleModelCell {

    typealias ModelType = RealmModel
    var model:RealmModel? {
        didSet {
            guard let m = model else {return}
            nameLabel.text = "Unlocked \(m.refSkill.name)"
            valueLabel.text = "Level \(m.level)"
        }
    }

    
}
