//  Created by Alexander Skorulis on 20/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension CGPoint {
    func distance(_ other:CGPoint) -> CGFloat {
        return sqrt((self.x - other.x)*(self.x - other.x) + (self.y - other.y)*(self.y - other.y))
    }
    
    func length() -> CGFloat {
        return self.distance(CGPoint(x: 0, y: 0))
    }
    
    func angle() -> CGFloat {
        let val = self.y == 0 ? 0 : atan(self.x/self.y)
        if y == 0 {
            return x > 0 ? CGFloat(Double.pi/2) : CGFloat(3*Double.pi/2)
        } else if x > 0 && y > 0 {
            return val
        } else if x < 0 && y > 0 {
            return val + CGFloat(Double.pi*2)
        } else if x < 0 && y < 0 {
            return val + CGFloat(Double.pi)
        } else {
            return val + CGFloat(Double.pi)
        }
        
    }
}
