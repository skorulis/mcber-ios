//  Created by Alexander Skorulis on 10/11/16.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

import UIKit
import FontAwesomeKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

class FixedSizeButton: UIButton {
    
    let fixedSize:CGFloat
    
    init(fixedSize:CGFloat) {
        self.fixedSize = fixedSize
        super.init(frame: CGRect(x: 0, y: 0, width: fixedSize, height: fixedSize))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize { return CGSize(width: fixedSize, height: fixedSize) }
}

public class ThemeImages: NSObject {
    
    func mapButton() -> UIImage {
        let icon = FAKFontAwesome.mapOIcon(withSize: 20)
        let image = icon?.image(with: CGSize(width: 24, height: 30))
        return image!
    }
    
    init(color:ThemeColors) {
    
    }
    
}

public class ThemeColors: NSObject {
    
    public let defaultText = UIColor(netHex: 0x252525)
    public let disabledText = UIColor(netHex: 0xABABAB)
    
    public let defaultBackground:UIColor
    
    public let deselectedColor = UIColor(netHex: 0xAAAAAA)
    public let selectedColor = UIColor(netHex: 0x3333BB)

    
    public override init() {
        defaultBackground = UIColor.white
    }
}

public class ThemeFonts: NSObject {
    public let title = UIFont.boldSystemFont(ofSize: 22)
    public let basic = UIFont.systemFont(ofSize: 14)
}

public class ThemePadding: NSObject {
    public let top = CGFloat(4)
    public let bot = CGFloat(4)
    public let left = CGFloat(8)
    public let right = CGFloat(8)
    public let innerY = CGFloat(4)
    
    public let edges:UIEdgeInsets
    
    public override init() {
        edges = UIEdgeInsets(top: top, left: left, bottom: bot, right: right)
    }
}

public class ThemeService: NSObject {
    public static var theme:ThemeService!
    
    public let color = ThemeColors()
    public let font = ThemeFonts()
    public let padding = ThemePadding()
    public let image: ThemeImages
    
    override init() {
        image = ThemeImages(color: color)
    }
    
    func setupAppearance() {
        
    }
        
}
