//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

class ForwardNavigationViewModel {
    let text:String
    let color:UIColor
    
    init(text:String,color:UIColor = ThemeService.theme.color.defaultText) {
        self.text = text
        self.color = color
    }
}

class ForwardNavigationHeader: ThemedCollectionReusableView {

    let label = UILabel()
    let chevron = UILabel()
    let gesture = UITapGestureRecognizer(target: nil, action: nil)
    
    var textColor:UIColor = ThemeService.theme.color.defaultText {
        didSet {
            label.textColor = textColor
            updateChevron()
        }
    }
    
    private func updateChevron() {
        let icon = FAKFontAwesome.chevronRightIcon(withSize: 24)
        icon?.addAttribute(NSAttributedStringKey.foregroundColor.rawValue, value: textColor)
        chevron.attributedText = icon?.attributedString()
    }
    
    override func buildView(theme: ThemeService) {
        self.addSubview(label)
        label.text = "Something"
        label.font = theme.font.title
        label.textColor = textColor
        
        updateChevron()
        
        self.addSubview(chevron)

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
