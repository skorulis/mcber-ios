//  Created by Alexander Skorulis on 1/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import XCTest
import ObjectMapper
@testable import Mcber

class MonitoredArrayTests: XCTestCase {
    
    func testArrayChanges() {
        
        var result = [String]()
        
        let monitor = MonitoredArray(array:[String]())
        monitor.observers.add(object: self) { (change) in
            XCTAssertEqual([], change.oldValue)
            result = change.array.array
        }
        monitor.array.append("TEST1")
        
        XCTAssertEqual(result, ["TEST1"])
    }
    
    func testCascadeUp() {
        let a1 = MonitoredArray(array: ["TEST"])
        let a2 = MonitoredArray(array: [Int]())
        
        a1.watch(array:a2)
        
        var result = [String]()
        
        a1.observers.add(object: self) { (change) in
            result = change.array.array
        }
        a2.array = [1]
        
        XCTAssertEqual(result, ["TEST"])
        XCTAssertEqual(a2.array, [1])
    }
    
    func testPreventDoubleWatch() {
        let a1 = MonitoredArray(array: ["TEST"])
        let a2 = MonitoredArray(array: [Int]())
        
        a1.watch(array: a2)
        a1.watch(array: a2)
        
        XCTAssertEqual(a2.observers.observerCount(),1)
    }
    
    func testObserverCopy() {
        let a1 = MonitoredArray(array: ["TEST"])
        let a2 = MonitoredArray(array: ["TEST2"])
        
        var result = [String]()
        
        a1.observers.add(object: self) { (change) in
            XCTAssertEqual(change.oldValue, ["TEST2"])
            result = change.array.array
        }
        
        a2.copyObservers(from: a1)
        a2.array.append("TEST3")
        XCTAssertEqual(result, ["TEST2","TEST3"])
        
    }
    
    
}
