//  Created by Alexander Skorulis on 9/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit


final class BattleSummaryCell: ThemedCollectionViewCell, AutoSizeModelCell {

    let avatar1Damage = UILabel()
    let avatar2Damage = UILabel()
    
    static var sizingCell: BattleSummaryCell = setupCell(cell: BattleSummaryCell())
    typealias ModelType = BattleResultModel
    var model: BattleResultModel? {
        didSet {
            guard let model = model else { return }
            avatar1Damage.text = "\(model.a1TotalDamage) Damage"
            avatar2Damage.text = "\(model.a2TotalDamage) Damage"
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(avatar1Damage)
        self.contentView.addSubview(avatar2Damage)
    }
    
    override func buildLayout(theme: ThemeService) {
        avatar1Damage.snp.makeConstraints { (make) in
            make.top.bottom.left.equalToSuperview().inset(theme.padding.edges)
        }
        
        avatar2Damage.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview().inset(theme.padding.edges)
        }
    }
    
}
