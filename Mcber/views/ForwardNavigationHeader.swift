//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

class ForwardNavigationHeader: ThemedCollectionReusableView {

    let label = UILabel()
    let chevron = UILabel()
    let gesture = UITapGestureRecognizer(target: nil, action: nil)
    
    
    override func buildView(theme: ThemeService) {
        self.addSubview(label)
        label.text = "Something"
        label.font = theme.font.title
        label.textColor = theme.color.defaultText
        
        let icon = FAKFontAwesome.chevronRightIcon(withSize: 24)
        icon?.addAttribute(NSForegroundColorAttributeName, value: theme.color.defaultText)
        
        self.addSubview(chevron)
        chevron.attributedText = icon?.attributedString()
        
        self.addGestureRecognizer(gesture)
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
    
    class func curriedDefaultHeader(text:String) -> (UICollectionView,String,IndexPath) -> ForwardNavigationHeader {
        return { collectionView,kind,indexPath in
            let view:ForwardNavigationHeader = collectionView.dequeueSetupView(kind: kind, indexPath: indexPath, theme: ThemeService.theme)
            view.label.text = text
            return view
        }
    }
    
    func addTapTarget(target:Any, action:Selector) {
        gesture.removeTarget(nil, action: nil)
        gesture.addTarget(target, action: action)
    }


}
