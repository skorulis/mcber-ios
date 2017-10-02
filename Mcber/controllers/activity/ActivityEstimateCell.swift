//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ActivityEstimateCell: ThemedCollectionViewCell, SimpleModelCell {
 
    let mainLabel = UILabel()
    
    typealias ModelType = ActivityModel
    var model:ActivityModel? {
        didSet {
            if let model = model {
                mainLabel.text = "Duration \(model.calculated.duration)"
            } else {
                mainLabel.text = "Select all paramaters to start"
            }
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(mainLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        mainLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(theme.padding.edges)
        }
    }
    
}
