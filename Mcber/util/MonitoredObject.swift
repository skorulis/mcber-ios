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

protocol IdUpdateableProtocol: IdObjectProtocol {
    func update(old:IdUpdateableProtocol)
}

struct MonitoredArrayChange<Element> {
    let array: MonitoredArray<Element>
    let oldValues: [Element]
    
    func findOldById(id:String) -> Element? {
        return oldValues.filter { (element) -> Bool in
            if let e = element as? IdObjectProtocol {
                return e._id == id
            }
            return false
        }.first
    }
}

class MonitoredArray<Element>: ArrayDataSourceProtocol {
    typealias ElementType = Element;
    
    let observers = ObserverSet<MonitoredArrayChange<Element>>()
    
    private var arrayPrivate:[Element]
    
    var array:[Element] {
        get { return arrayPrivate}
        set {
            let change = MonitoredArrayChange(array: self, oldValues: arrayPrivate)
            for obj in newValue {
                if let updatingObj = obj as? IdUpdateableProtocol {
                    if let old = change.findOldById(id: updatingObj._id) {
                        updatingObj.update(old: old as! IdUpdateableProtocol)
                    }
                }
            }
            arrayPrivate = newValue
            observers.notify(parameters: change)
        }
        
    }
    
    init(array:[Element]) {
        self.arrayPrivate = array
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
    
    func watch<T>(array:MonitoredArray<T>) {
        array.observers.add(object: self) {[weak self] (_) in
            if let s = self {
                let change = MonitoredArrayChange(array: s, oldValues: s.arrayPrivate)
                s.observers.notify(parameters: change)
            }
        }
    }
    
    func copyObservers(from:MonitoredArray<Element>) {
        self.observers.copyObservers(from: from.observers)
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
