//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

struct ExperienceGainViewModel {
    let xp:ExperienceGainModel
    let skill:SkillModel
}

class ExperienceGainCell: ThemedCollectionViewCell, SimpleModelCell {

    let nameLabel = UILabel()
    let amountLabel = UILabel()
    
    typealias ModelType = ExperienceGainViewModel
    var model:ExperienceGainViewModel? {
        didSet {
            guard let m = model else {return}
            nameLabel.text = m.skill.name
            amountLabel.text = "+\(m.xp.xp) XP"
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(amountLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(theme.padding.edges)
        }
        
        amountLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(theme.padding.edges)
        }
    }

}
