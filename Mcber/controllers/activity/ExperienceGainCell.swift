//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

struct ExperienceGainViewModel {
    let xp:ExperienceGainModel
    let skill:SkillModel
}

class ExperienceGainCell: BasicKeyValueCell, SimpleModelCell {
    
    typealias ModelType = ExperienceGainViewModel
    var model:ExperienceGainViewModel? {
        didSet {
            guard let m = model else {return}
            nameLabel.text = m.skill.name
            valueLabel.text = "+\(m.xp.xp) XP"
        }
    }
    
}
