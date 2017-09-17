//  Created by Alexander Skorulis on 17/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class BasicKeyValueCell: ThemedCollectionViewCell {
    
    let nameLabel = UILabel()
    let valueLabel = UILabel()
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(valueLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(theme.padding.edges)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(theme.padding.edges)
        }
    }


}
