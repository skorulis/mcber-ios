//  Created by Alexander Skorulis on 10/11/16.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

import UIKit

open class ThemedCollectionReusableView: UICollectionReusableView {
    
    var theme:ThemeService?
    
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
