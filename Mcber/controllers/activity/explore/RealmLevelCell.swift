//  Created by Alexander Skorulis on 15/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class RealmLevelCell: ThemedCollectionViewCell {
    
    let label = UILabel()
    
    override func buildView(theme: ThemeService) {
        label.textAlignment = .center
        self.contentView.addSubview(label)
        
    }
    
    override func buildLayout(theme: ThemeService) {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        
    }

}
