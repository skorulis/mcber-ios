//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

class AvatarViewModel {
    let avatar:AvatarModel
    var status:String = ""
    var statusColor = UIColor.green
    
    init(avatar:AvatarModel) {
        self.avatar = avatar
    }
    
}

final class AvatarCell: ThemedCollectionViewCell, AutoSizeModelCell {

    private let levelLabel = UILabel()
    private let healthLabel = UILabel()
    private let speedLabel = UILabel()
    private let elementBalance = AvatarBalanceView(frame: .zero, columnCount: 10)
    private let tradeBalance = AvatarBalanceView(frame: .zero, columnCount: 5)
    private let statusLabel = UILabel()
    
    private let ref = ReferenceService.instance!
    
    static var sizingCell: AvatarCell = setupCell(cell: AvatarCell())
    typealias ModelType = AvatarViewModel
    var model:AvatarViewModel? {
        didSet {
            if let m = model {
                let avatar = m.avatar
                levelLabel.text = "Level: \(avatar.level)"
                healthLabel.text = "Health: \(avatar.stats.otherValue(type: .health))"
                speedLabel.text = "Speed: \(avatar.stats.otherValue(type: .speed))"
                
                elementBalance.models = avatar.stats.skills.filter { $0.ref.type == .element }
                tradeBalance.models = avatar.stats.skills.filter { $0.ref.type == .trade }
                
                statusLabel.text = m.status
                statusLabel.textColor = m.statusColor
            }
        }
    }
    
    override func buildView(theme: ThemeService) {
        tradeBalance.reversed = true
        
        self.contentView.addSubview(levelLabel)
        self.contentView.addSubview(healthLabel)
        self.contentView.addSubview(speedLabel)
        self.contentView.addSubview(elementBalance)
        self.contentView.addSubview(tradeBalance)
        self.contentView.addSubview(statusLabel)
        
        statusLabel.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi/4))
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
        
        elementBalance.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(speedLabel.snp.bottom)
            make.height.equalTo(24).priority(750)
        }
        
        tradeBalance.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(elementBalance.snp.bottom).offset(2)
            make.height.equalTo(elementBalance)
        }
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.width.equalTo(statusLabel.snp.height)
            make.bottom.equalTo(elementBalance.snp.top)
        }
    }

}
