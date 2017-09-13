//  Created by Alexander Skorulis on 10/11/16.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

import UIKit

open class ThemedCollectionViewCell: UICollectionViewCell {
    
    var theme:ThemeService?
    var fixedWidthConstraint:NSLayoutConstraint?
    
    @discardableResult open func setup(theme:ThemeService,withWidth:CGFloat) -> Bool {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        if fixedWidthConstraint == nil {
            fixedWidthConstraint = NSLayoutConstraint(item: self.contentView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: withWidth)
            self.contentView.addConstraint(fixedWidthConstraint!)
        } else {
            fixedWidthConstraint?.constant = withWidth
        }
        return setup(theme: theme)
    }
    
    @discardableResult open func setup(theme:ThemeService) -> Bool {
        if(self.theme != nil) {
            return true
        }
        self.theme = theme
        self.buildView(theme: theme)
        self.buildLayout(theme: theme)
        return false
    }
    
    open func buildView(theme:ThemeService) {
        
    }
    
    open func buildLayout(theme:ThemeService) {
        
    }
    
    
}
