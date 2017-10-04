//  Created by Alexander Skorulis on 4/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

extension NSObject {
    func unown<T: AnyObject, U, V>(instance: T, _ classFunction:@escaping (T)->(U)->(V)) -> (U)->(V) {
        return { [unowned instance] args in
            let instanceFunction = classFunction(instance)
            return instanceFunction(args)
        }
    }
}
