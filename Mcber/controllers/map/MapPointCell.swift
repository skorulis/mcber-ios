//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MapPointCell: ThemedCollectionViewCell, SimpleModelCell {
    
    let selectionView = UIView()
    
    typealias ModelType = MapPointModel
    var model:MapPointModel? {
        didSet {
            guard let model = model else {return}
            selectionView.backgroundColor = self.pointColor(point: model)
            contentView.layer.borderColor = selectionView.backgroundColor?.cgColor
        }
    }
    
    override func buildView(theme: ThemeService) {
        selectionView.clipsToBounds = true
        selectionView.alpha = 0
        
        self.contentView.layer.borderColor = UIColor.blue.cgColor
        self.contentView.layer.borderWidth = 2
        self.contentView.clipsToBounds = true
        self.contentView.backgroundColor = UIColor.white
        self.contentView.addSubview(selectionView)
        
    }
    
    override func buildLayout(theme: ThemeService) {
        selectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().inset(4)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = self.frame.width/2
        selectionView.layer.cornerRadius = selectionView.frame.width/2
    }
    
    func pointColor(point:MapPointModel) -> UIColor {
        if point.affiliation.count == 0 {
            return UIColor(netHex: 0xf4c242)
        }
        return point.affiliation.first!.skill.color
    }
    
    override var isHighlighted: Bool {
        didSet {
            selectionView.alpha = isHighlighted ? 1 : 0
            selectionView.layer.cornerRadius = selectionView.frame.width/2
        }
    }
    
    override var isSelected: Bool {
        didSet {
            selectionView.alpha = isSelected ? 1 : 0
            selectionView.layer.cornerRadius = selectionView.frame.width/2
        }
    }
    
}
