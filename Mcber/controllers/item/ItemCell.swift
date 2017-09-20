//  Created by Alexander Skorulis on 20/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ItemCell: ThemedCollectionViewCell, SimpleModelCell {

    typealias ModelType = ItemModel
    var model: ItemModel? {
        didSet {
            nameLabel.text = model?.name
        }
    }
    
    let nameLabel = UILabel()
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(nameLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        nameLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
