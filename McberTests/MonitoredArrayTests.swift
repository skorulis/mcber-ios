//  Created by Alexander Skorulis on 1/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import XCTest
import ObjectMapper
@testable import Mcber

class MonitoredArrayTests: XCTestCase {
    
    func testArrayChanges() {
        
        var result = [String]()
        
        let monitor = MonitoredArray(array:[String]())
        monitor.observers.add(object: self) { (monitoredArray) in
            result = monitoredArray.array
        }
        monitor.array.append("TEST1")
        
        XCTAssertEqual(result, ["TEST1"])
    }
    
    
}
