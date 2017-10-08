//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

protocol ArrayDataSourceProtocol {
    associatedtype ElementType
    func elementAt(indexPath:IndexPath) -> ElementType
    func elementCount() -> Int
}

protocol IdObjectProtocol {
    var _id:String { get }
}

class MonitoredObject<T>: ArrayDataSourceProtocol {
    typealias ElementType = T;
    
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
    
    func elementAt(indexPath:IndexPath) -> T {
        return value
    }
    
    func elementCount() -> Int {
        return 1
    }
}

class MonitoredArray<Element>: ArrayDataSourceProtocol {
    typealias ElementType = Element;
    
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

class OptionalMonitoredObject<Element>: MonitoredArray<Element> {
    
    var object:Element? {
        didSet {
            if let e = object {
                array = [e]
            } else {
                array = []
            }
        }
    }
    
    init(element:Element?) {
        var a:[Element] = []
        if let e = element {
            a.append(e)
        }
        super.init(array: a)
    }
    
}
