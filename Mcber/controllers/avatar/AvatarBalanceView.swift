//  Created by Alexander Skorulis on 17/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class AvatarBalanceView: UIView {
    
    let columns:[UIView]
    var reversed = false
    
    init(frame: CGRect,columnCount:Int) {
        var temp = [UIView]()
        for _ in 0..<columnCount {
            temp.append(UIView())
        }
        columns = temp
        super.init(frame: frame)
        for col in columns {
            self.addSubview(col)
        }
    }
    
    var models:[StatSkill]? {
        didSet {
            guard let list = models else {return}
            assert(list.count == columns.count)
            
            let maxLevel:Double = Double(max(list.map { $0.level }.max()!,1))
            for index in 0..<list.count {
                let skill = list[index]
                let col = self.columns[index]
                let pct = Double(skill.level) / maxLevel
                col.backgroundColor = skill.ref.color
                col.snp.remakeConstraints({ (make) in
                    if self.reversed {
                        make.top.equalToSuperview()
                    } else {
                        make.bottom.equalToSuperview()
                    }
                    
                    make.height.equalToSuperview().multipliedBy(pct).priority(750)
                    make.height.greaterThanOrEqualTo(1)
                    if index == 0 {
                        make.left.equalToSuperview().inset(2)
                    } else {
                        make.left.equalTo(columns[index-1].snp.right).offset(2)
                        make.width.equalTo(columns[index-1])
                    }
                    if index == list.count - 1 {
                        make.right.equalToSuperview().inset(2)
                    }
                })
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

 
}
