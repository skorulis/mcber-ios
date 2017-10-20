//  Created by Alexander Skorulis on 20/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension CGPoint {
    func distance(_ other:CGPoint) -> CGFloat {
        return sqrt((self.x - other.x)*(self.x - other.x) + (self.y - other.y)*(self.y - other.y))
    }
}
