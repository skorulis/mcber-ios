//  Created by Alexander Skorulis on 17/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension UIColor {
    
    func mix(overlay: UIColor,amount:CGFloat) -> UIColor {
        var bgR: CGFloat = 0
        var bgG: CGFloat = 0
        var bgB: CGFloat = 0
        var bgA: CGFloat = 0
        
        var fgR: CGFloat = 0
        var fgG: CGFloat = 0
        var fgB: CGFloat = 0
        var fgA: CGFloat = 0
        
        self.getRed(&bgR, green: &bgG, blue: &bgB, alpha: &bgA)
        overlay.getRed(&fgR, green: &fgG, blue: &fgB, alpha: &fgA)
        
        let r = amount * fgR + (1 - amount) * bgR
        let g = amount * fgG + (1 - amount) * bgG
        let b = amount * fgB + (1 - amount) * bgB
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}
