//  Created by Alexander Skorulis on 22/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

extension UIBarButtonItem {

    convenience init(icon:FAKIcon,target:Any?,selector:Selector?) {
        let image = icon.image(with: CGSize(width: 40, height: 40))
        self.init(image: image, style: .plain, target: target, action: selector)
    }
    
}
