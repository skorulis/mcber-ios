//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

protocol IdObjectProtocol {
    var _id:String { get }
}

class MonitoredObject<T> {

    var value:T
    
    var valueDidChange:( (T,T) -> ())?
    
    
    init(initialValue:T) {
        self.value = initialValue
    }
    
    func updateIfEqual(newValue:T) {
        guard let idValue = self.value as? IdObjectProtocol, let newIdValue = newValue as? IdObjectProtocol else {
            return
        }
        
        guard (idValue._id == newIdValue._id) else {
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
    
    let observers = ObserverSet<MonitoredArray<Element>>()
    
    var array:[Element] {
        didSet {
            observers.notify(parameters: self)
        }
    }
    
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
