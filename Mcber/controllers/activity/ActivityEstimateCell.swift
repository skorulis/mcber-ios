//  Created by Alexander Skorulis on 2/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

struct ActivityViewModel {
    let activity:ActivityModel
    let user:UserModel
    let theme:ThemeService
    
    func leftText() -> String {
        var text = "Duration \(activity.calculated.duration) seconds\nSkill level \(activity.calculated.skillLevel)"
        if let failure = activity.calculated.failureChance {
            let failureInt = Int(failure*100)
            text = text + "\nFailure chance \(failureInt)%"
        }
        return text
    }
    
    func rightText() -> NSAttributedString {
        let mas = NSMutableAttributedString()
        for r in activity.calculated.resources {
            let color = user.hasResource(resource: r) ? theme.color.defaultText : theme.color.error
            let string = "\(r.quantity) \(r.refModel.name)\n"
            let att = NSAttributedString(string: string, attributes: [NSAttributedStringKey.foregroundColor:color])
            mas.append(att)
        }
        return mas
    }
}

final class ActivityEstimateCell: ThemedCollectionViewCell, AutoSizeModelCell {
 
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    let rightHeader = UILabel()
    
    static var sizingCell: ActivityEstimateCell = {
        let cell = ActivityEstimateCell()
        cell.setup(theme: ThemeService.theme)
        return cell
    }()
    
    typealias ModelType = ActivityViewModel
    var model:ActivityViewModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            leftLabel.text = model.leftText()
            rightHeader.text = "Resources"
            
            rightLabel.attributedText = model.rightText()
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
            make.bottom.lessThanOrEqualToSuperview().inset(theme.padding.edges)
        }
        
    }
    
}
