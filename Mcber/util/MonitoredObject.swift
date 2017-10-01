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

class MonitoredArray<Element> {
    
    private var array:[Element]
    
    init(array:[Element]) {
        self.array = array
    }
    
    func elementAt(indexPath:IndexPath) -> Element {
        return self.array[indexPath.row]
    }
    
    func elementCount() -> Int {
        return self.array.count
    }
    
    func append(_ newElement: Element) {
        self.array.append(newElement)
    }
    
    func forEach(_ body: (Element) throws -> Void) rethrows {
        try self.array.forEach(body)
    }
    
    func index(where predicate: (Element) throws -> Bool) rethrows -> Int? {
        return try self.array.index(where: predicate)
    }
    
    subscript(index: Int) -> Element {
        get { return self.array[index] }
        set(newValue) { self.array[index] = newValue }
    }



}
