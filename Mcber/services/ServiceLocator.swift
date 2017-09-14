//  Created by Alexander Skorulis on 12/5/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit

class ServiceLocator: NSObject {

    let theme:ThemeService
    let analytics:AnalyticsService
    let ref:ReferenceService
    let api:MainAPIService
    let login:LoginService
    let state:GameStateService
    
    override init() {
        theme = ThemeService()
        ThemeService.theme = theme
        theme.setupAppearance()
        analytics = AnalyticsService()
        
        ref = ReferenceService()
        ReferenceService.instance = ref
        _ = ref.getAllReferenceData()
        
        state = GameStateService()
        api = MainAPIService()
        login = LoginService(api: api,state:state)
    }
    
}
