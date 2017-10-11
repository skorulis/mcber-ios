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

class MonitoredObject<Element>: MonitoredArray<Element> {
    
    var value:Element {
        set {
            array[0] = newValue
        }
        get {
            return array[0]
        }
    }
    
    init(initialValue:Element) {
        super.init(array: [initialValue])
    }
    
    func updateIfEqual(newValue:Element) {
        guard let idValue = self.value as? IdObjectProtocol, let newIdValue = newValue as? IdObjectProtocol else {
            return
        }
        
        guard (idValue._id == newIdValue._id) else {
            return
        }
        self.value = newValue
    }
    
}

class OptionalMonitoredObject<Element>: MonitoredArray<Element> {
    
    var object:Element? {
        set {
            if let e = newValue {
                array = [e]
            } else {
                array = []
            }
        }
        get {
            return array.first
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
