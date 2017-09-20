//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit


class ExperienceGainCell: BasicKeyValueCell, SimpleModelCell {
    
    typealias ModelType = ExperienceGainModel
    var model:ExperienceGainModel? {
        didSet {
            guard let m = model else {return}
            nameLabel.text = m.refSkill.name
            valueLabel.text = "+\(m.xp) XP"
        }
    }
    
}
