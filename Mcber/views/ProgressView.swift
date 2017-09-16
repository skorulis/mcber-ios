//  Created by Alexander Skorulis on 16/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import SnapKit

class ProgressView: UIView {

    let fullView = UIView()
    let label = UILabel()
    var completeFraction:Double {
        didSet {
            self.updateFullFrame()
        }
    }
    
    override init(frame: CGRect) {
        completeFraction = 0
        super.init(frame: frame)
        self.addSubview(fullView)
        self.addSubview(label)
        
        label.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(self).offset(20)
        }
        
        self.backgroundColor = UIColor.gray
        fullView.backgroundColor = UIColor.orange
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateFullFrame()
    }
    
    func updateFullFrame() {
        let width = self.frame.width * CGFloat(1 - completeFraction)
        fullView.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.height)
    }
    
    func setFraction(startValue:Double,finishValue:Double,currentValue:Double) {
        let total = finishValue - startValue
        let remaining = finishValue - currentValue
        self.completeFraction = max(0, remaining / total)
    }
       
}
