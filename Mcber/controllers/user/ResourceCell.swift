//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ResourceCell: ThemedCollectionViewCell, SimpleModelCell {

    let nameLabel = UILabel()
    let quantityLabel = UILabel()
    
    typealias ModelType = (ResourceModel, ResourceRefModel)
    
    var model: (ResourceModel, ResourceRefModel)? {
        didSet {
            if let resource = model?.0, let ref = model?.1 {
                nameLabel.text = ref.name
                quantityLabel.text = "\(resource.quantity)"
            }
            
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(quantityLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        nameLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().inset(theme.padding.edges)
        }
        
        quantityLabel.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(theme.padding.edges)
        }
    }
    
}
