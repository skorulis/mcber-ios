//  Created by Alexander Skorulis on 21/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class TestSizeCell: ThemedCollectionViewCell {

    let label = UILabel()
    
    override func buildView(theme: ThemeService) {
        label.numberOfLines = 0
        label.text = "asfagpweof oif Isn't the punk scene about not conforming to standards and letting people li It's the follow up that gets me: \"And I don't want to talk to a scientist; motherfuckers lyin' and gettin' me pissed\" If you're curious about magnets scientists are the exact people you should be talking to."
        self.contentView.addSubview(label)
        
        
    }
    
    override func buildLayout(theme: ThemeService) {
        label.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(200)
        }
        
        //label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: .vertical)
        //label.setContentHuggingPriority(UILayoutPriorityRequired, for: .vertical)
    }

}
