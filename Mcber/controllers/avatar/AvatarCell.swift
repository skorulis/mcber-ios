//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

final class AvatarCell: ThemedCollectionViewCell, AutoSizeModelCell {

    private let levelLabel = UILabel()
    private let healthLabel = UILabel()
    private let speedLabel = UILabel()
    private let elementBalance = AvatarBalanceView(frame: .zero, columnCount: 10)
    private let tradeBalance = AvatarBalanceView(frame: .zero, columnCount: 5)
    
    private let ref = ReferenceService.instance!
    
    static var sizingCell: AvatarCell = setupCell(cell: AvatarCell())
    typealias ModelType = AvatarModel
    var model:AvatarModel? {
        didSet {
            if let m = model {
                levelLabel.text = "Level: \(m.level)"
                healthLabel.text = "Health: \(m.stats.otherValue(type: .health))"
                speedLabel.text = "Speed: \(m.stats.otherValue(type: .speed))"
                
                elementBalance.models = m.stats.skills.filter { $0.ref.type == .element }
                tradeBalance.models = m.stats.skills.filter { $0.ref.type == .trade }
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
        }
        
        tradeBalance.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(elementBalance.snp.bottom).offset(2)
            make.height.equalTo(elementBalance)
        }
    }

}
