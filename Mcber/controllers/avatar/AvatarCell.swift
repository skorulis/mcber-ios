//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

class AvatarCell: ThemedCollectionViewCell {

    private let levelLabel = UILabel()
    private let healthLabel = UILabel()
    private let speedLabel = UILabel()
    
    var model:AvatarModel? {
        didSet {
            if let m = model {
                levelLabel.text = "Level: \(m.level)"
                healthLabel.text = "Health: \(m.health)"
                speedLabel.text = "Speed: \(m.speed)"
            }
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(levelLabel)
        self.contentView.addSubview(healthLabel)
        self.contentView.addSubview(speedLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        self.levelLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(theme.padding.edges)
        }
        
        self.healthLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.levelLabel.snp.bottom).offset(2)
            make.left.equalTo(self.levelLabel)
        }
        
        self.speedLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.healthLabel.snp.bottom).offset(2)
            make.left.equalTo(self.healthLabel)
        }
    }

}
