//  Created by Alexander Skorulis on 3/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

final class BaseGemCell: ThemedCollectionViewCell,AutoSizeModelCell {
    
    let label = UILabel()
    
    static var sizingCell: BaseGemCell = setupCell(cell: BaseGemCell())
    typealias ModelType = ItemModRef
    var model: ItemModRef? {
        didSet {
            label.text = model?.postfix
        }
    }
    
    override func buildView(theme: ThemeService) {
        label.numberOfLines = 0
        self.contentView.addSubview(label)
    }
    
    override func buildLayout(theme: ThemeService) {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(theme.padding.edges)
        }
    }
}
