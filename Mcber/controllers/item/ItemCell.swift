//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemCell: ThemedCollectionViewCell, SimpleModelCell {

    let nameLabel = UILabel()
    let modTextLabel = UILabel()
    
    typealias ModelType = ItemModel
    var model: ItemModel? {
        didSet {
            guard let m = model else { return }
            self.nameLabel.text = "Level \(m.totalPower) m.name"
            modTextLabel.text = m.modDescriptions()
        }
    }
    
    override func buildView(theme: ThemeService) {
        modTextLabel.numberOfLines = 0
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(modTextLabel)
        
        nameLabel.preferredMaxLayoutWidth = 300
        modTextLabel.preferredMaxLayoutWidth = 300
    }
    
    override func buildLayout(theme: ThemeService) {
        nameLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview().inset(theme.padding.edges)
        }
        modTextLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(theme.padding.edges)
            make.top.equalTo(nameLabel.snp.bottom)
            make.bottom.lessThanOrEqualTo(self.contentView.snp.bottom).inset(theme.padding.bot)
        }
    }
    
    func calculateHeight(model:ItemModel) -> CGFloat {
        self.model = model
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        return self.modTextLabel.frame.maxY + self.theme!.padding.bot
    }
    
}
