//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

final class ActivityEstimateCell: ThemedCollectionViewCell, AutoSizeModelCell {
 
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    let rightHeader = UILabel()
    
    static var sizingCell: ActivityEstimateCell = {
        let cell = ActivityEstimateCell()
        cell.setup(theme: ThemeService.theme)
        return cell
    }()
    
    typealias ModelType = ActivityModel
    var model:ActivityModel? {
        didSet {
            guard let model = model else {
                return
            }
            leftLabel.text = "Duration \(model.calculated.duration) seconds\nSkill level \(model.calculated.skillLevel)"
            rightHeader.text = "Resources"
            rightLabel.text = "Fire 1\n Something 10"
        }
    }
    
    override func buildView(theme: ThemeService) {
        leftLabel.numberOfLines = 0
        
        rightHeader.textAlignment = .center
        rightLabel.numberOfLines = 0
        
        self.contentView.addSubview(leftLabel)
        self.contentView.addSubview(rightHeader)
        self.contentView.addSubview(rightLabel)
    }
    
    override func buildLayout(theme: ThemeService) {
        leftLabel.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().inset(theme.padding.edges)
            make.bottom.lessThanOrEqualToSuperview().inset(theme.padding.bot)
            make.width.equalTo(rightHeader)
        }
        
        rightHeader.snp.makeConstraints { (make) in
            make.left.equalTo(leftLabel.snp.right)
            make.right.equalToSuperview().inset(theme.padding.edges)
        }
        
        rightLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(rightHeader)
            make.top.equalTo(rightHeader.snp.bottom)
            make.bottom.equalToSuperview().inset(theme.padding.edges)
        }
        
    }
    
}
