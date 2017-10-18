//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapPointCell: ThemedCollectionViewCell, SimpleModelCell {
    
    typealias ModelType = MapPointModel
    var model:MapPointModel? {
        didSet {
            guard let model = model else {return}
            contentView.layer.borderColor = self.pointColor(point: model).cgColor
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.layer.borderColor = UIColor.blue.cgColor
        self.contentView.layer.borderWidth = 2
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.white
    }
    
    override func buildLayout(theme: ThemeService) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = self.frame.width/2
    }
    
    func pointColor(point:MapPointModel) -> UIColor {
        if point.affiliation.count == 0 {
            return UIColor(netHex: 0xf4c242)
        }
        return point.affiliation.first!.skill.color
    }
    
}
