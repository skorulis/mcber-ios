//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarSkillCell: ThemedCollectionViewCell {

    let nameLabel = UILabel()
    let levelLabel = UILabel()
    let progressView = ProgressView()
    
    var model:(SkillProgressModel,ElementalSkillModel)? {
        didSet {
            if let skill = model?.1, let progress = model?.0 {
                nameLabel.text = skill.name
                levelLabel.text = "Level: \(progress.level)"
                progressView.label.text = "\(progress.xp) / \(progress.xpNext)"
                progressView.setFraction(startValue: 0, finishValue: Double(progress.xpNext), currentValue: Double(progress.xp))
            }
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(levelLabel)
        self.contentView.addSubview(progressView)
    }
    
    override func buildLayout(theme: ThemeService) {
        nameLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(theme.padding.edges)
        }
        levelLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
        }
        progressView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
}