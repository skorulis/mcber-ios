//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

final class ItemCell: ThemedCollectionViewCell, SimpleModelCell, AutoSizeModelCell {

    let nameLabel = UILabel()
    let modTextLabel = UILabel()
    
    let deleteButton = UIButton()
    
    var deleteBlock: ((ItemModel) -> ())? {
        didSet {
            deleteButton.isHidden = deleteBlock == nil
        }
    }
    
    static var sizingCell: ItemCell = setupCell(cell: ItemCell())
    typealias ModelType = ItemModel
    var model: ItemModel? {
        didSet {
            deleteButton.isHidden = deleteBlock == nil
            guard let m = model else {
                self.nameLabel.text = "No item"
                self.modTextLabel.text = nil
                return
            }
            self.nameLabel.text = "Level \(m.totalPower) \(m.refId)"
            modTextLabel.text = m.modDescriptions()
        }
    }
    
    override func buildView(theme: ThemeService) {
        modTextLabel.numberOfLines = 0
        let icon = FAKFontAwesome.trashIcon(withSize: 24)
        deleteButton.setAttributedTitle(icon?.attributedString(), for: .normal)
        deleteButton.addTarget(self, action: #selector(deletePressed(sender:)), for: .touchUpInside)
        
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(modTextLabel)
        self.contentView.addSubview(deleteButton)
        
        //nameLabel.preferredMaxLayoutWidth = 300
        //modTextLabel.preferredMaxLayoutWidth = 300
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
        
        deleteButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview().inset(theme.padding.edges)
            make.width.height.equalTo(44)
        }
    }
    
    @objc func deletePressed(sender:Any) {
        deleteBlock?(self.model!)
    }
    
    func calculateHeight(model:ItemModel) -> CGFloat {
        self.model = model
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        return self.modTextLabel.frame.maxY + self.theme!.padding.bot
    }
    
}
