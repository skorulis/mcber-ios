//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

struct BasicTextViewModel {
    let text:String
}

final class ForwardNavigationCell: ThemedCollectionViewCell, AutoSizeModelCell {

    let label = UILabel()
    let chevron = UILabel()
    
    static var sizingCell: ForwardNavigationCell = setupCell(cell: ForwardNavigationCell())
    typealias ModelType = BasicTextViewModel
    var model: BasicTextViewModel? {
        didSet {
            self.label.text = model?.text
        }
    }
    
    override func buildView(theme: ThemeService) {
        self.contentView.addSubview(label)
        label.text = "Something"
        label.font = theme.font.title
        label.textColor = theme.color.defaultText
        
        let icon = FAKFontAwesome.chevronRightIcon(withSize: 24)
        icon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: theme.color.defaultText)
        
        self.contentView.addSubview(chevron)
        chevron.attributedText = icon?.attributedString()
    }
    
    override func buildLayout(theme: ThemeService) {
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.equalTo(40)
            make.left.equalToSuperview().offset(4)
        }
        
        chevron.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(theme.padding.right)
        }
    }
    
    class func curriedDefaultCell(text:String) -> (UICollectionView,IndexPath) -> ForwardNavigationCell {
        return { collectionView,indexPath in
            let cell:ForwardNavigationCell = collectionView.dequeueSetupCell(indexPath: indexPath, theme: ThemeService.theme)
            cell.label.text = text
            return cell
        }
    }
}
