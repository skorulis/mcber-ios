//  Created by Alexander Skorulis on 1/10/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import XCTest
import ObjectMapper
@testable import Mcber

class MonitoredArrayTests: XCTestCase {
    
    func testArrayChanges() {
        var array = [String]()
        
        let monitor = MonitoredArray(array:array)
        array.append("TEST1")
        array.append("TEST2")
    }
    
    
}
