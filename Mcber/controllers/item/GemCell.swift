//  Created by Alexander Skorulis on 1/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

final class GemCell: ThemedCollectionViewCell, SimpleModelCell, AutoSizeModelCell {
    
    let modTextLabel = UILabel()
    
    let deleteButton = UIButton()
    
    var deleteBlock: ((ItemGemModel) -> ())? {
        didSet {
            deleteButton.isHidden = deleteBlock == nil
        }
    }
    
    static var sizingCell: GemCell = setupCell(cell: GemCell())
    typealias ModelType = ItemGemModel
    var model: ItemGemModel? {
        didSet {
            deleteButton.isHidden = deleteBlock == nil
            self.modTextLabel.text = model?.userDescription()
        }
    }
    
    override func buildView(theme: ThemeService) {
        modTextLabel.numberOfLines = 0
        let icon = FAKFontAwesome.trashIcon(withSize: 24)
        deleteButton.setAttributedTitle(icon?.attributedString(), for: .normal)
        deleteButton.addTarget(self, action: #selector(deletePressed(sender:)), for: .touchUpInside)
        
        self.contentView.addSubview(modTextLabel)
        self.contentView.addSubview(deleteButton)
    }
    
    override func buildLayout(theme: ThemeService) {
        modTextLabel.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview().inset(theme.padding.edges)
            make.right.equalTo(deleteButton.snp.left)
        }
        
        deleteButton.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview().inset(theme.padding.edges)
            make.width.height.equalTo(44)
        }
    }
    
    @objc func deletePressed(sender:Any) {
        deleteBlock?(self.model!)
    }
    
}
