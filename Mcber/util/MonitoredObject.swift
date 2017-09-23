//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

protocol IdObjectProtocol {
    var _id:String { get }
}

class MonitoredObject<T:IdObjectProtocol> {

    var value:T
    
    var valueDidChange:( (T,T) -> ())?
    
    
    init(initialValue:T) {
        self.value = initialValue
    }
    
    func updateIfEqual(newValue:T) {
        guard (self.value._id == newValue._id) else {
            return
        }
        let oldValue = self.value
        self.value = newValue
        self.valueDidChange?(oldValue,newValue)
    }
    
    func at(indexpath:IndexPath) -> T {
        return value
    }
}
