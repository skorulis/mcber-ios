//  Created by Alexander Skorulis on 9/4/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import Foundation

public class ObserverToken {
    
}

public class ObserverSetEntry<Parameters> {
    fileprivate weak var object: AnyObject?
    fileprivate let f: (Parameters) -> Void
    
    fileprivate init(object: AnyObject, f: @escaping (Parameters) -> Void) {
        self.object = object
        self.f = f
    }
}

public class ObserverSet<Parameters>: CustomStringConvertible {
    
    private var entries: [ObserverSetEntry<Parameters>] = []
    
    public init() {}
    
    public func add(object: AnyObject, _ f: @escaping (Parameters) -> Void) {
        remove(object: object) //Remove the old monitor
        let entry = ObserverSetEntry<Parameters>(object: object, f: f)
        self.entries.append(entry)
    }
    
    public func add(f: @escaping (Parameters) -> Void) -> ObserverToken {
        let token = ObserverToken()
        let entry = ObserverSetEntry<Parameters>(object: token, f: f)
        self.entries.append(entry)
        return token
    }
    
    public func remove(object: AnyObject) {
        self.entries = self.entries.filter{ $0.object !== object }
    }
    
    public func notify(parameters: Parameters) {
        self.entries = self.entries.filter { $0.object != nil }
        self.entries.forEach { (entry) in
            entry.f(parameters)
        }
    }
    
    func observerCount() -> Int {
        return self.entries.count
    }
    
    func copyObservers(from:ObserverSet<Parameters>) {
        self.entries.append(contentsOf: from.entries.filter { $0.object != nil})
    }
    
    
    // MARK: CustomStringConvertible
    
    public var description: String {
        var entries: [ObserverSetEntry<Parameters>] = []
        entries = self.entries
        
        let strings = entries.map{
            entry in
            (entry.object === self
                ? "\(entry.f)"
                : "\(String(describing: entry.object)) \(entry.f)")
        }
        let joined = strings.joined(separator: ", ")
        
        return "\(Mirror(reflecting: self).description): (\(joined))"
    }
}
