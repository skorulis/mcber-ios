//  Created by Alexander Skorulis on 14/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

//This service is purely for storing and notifying about state changes. It should not be doing any logic except for merging partial states
class GameStateService: NSObject {

    let didChangeState = ObserverSet<UserModel>()
    
    var user:UserModel?
    
    var hasState: Bool {
        return user != nil
    }
    
    func resetState(user:UserModel) {
        self.user = user
        didChangeState.notify(parameters: user)
    }
    
}
