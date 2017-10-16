//  Created by Alexander Skorulis on 16/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class MonitoredArrayView<Type,SourceType>: MonitoredArray<Type> {

    var mapBlock: ((SourceType) -> (Type))?
    
}

extension MonitoredArray {
    
    func map<TypeNew>(block:@escaping (Element) -> (TypeNew)) -> MonitoredArrayView<TypeNew,Element> {
        let mappedValues = self.array.map{ block($0)}
        
        let arrayNew = MonitoredArrayView<TypeNew,Element>(array: mappedValues)
        arrayNew.mapBlock = block
        self.observers.add(object: arrayNew) { (change) in
            arrayNew.array = change.array.array.map { arrayNew.mapBlock!($0)}
        }
        return arrayNew
    }
    
}
