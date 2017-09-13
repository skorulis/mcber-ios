//  Created by Alexander Skorulis on 10/8/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import Crashlytics

class AnalyticsService: NSObject {

    public static var instance:AnalyticsService!
    
    func logPageView(vc:UIViewController) {
        let pageName = String.init(describing: vc.classForCoder)
        Answers.logContentView(withName: pageName, contentType: nil, contentId: nil, customAttributes: nil)
    }
    
}
