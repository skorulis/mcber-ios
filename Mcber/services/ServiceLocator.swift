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
    let activity:ActivityService
    let avatar:AvatarService
    let user:UserService
    let map:MapService
    
    override init() {
        theme = ThemeService()
        ThemeService.theme = theme
        theme.setupAppearance()
        analytics = AnalyticsService()
        
        ref = ReferenceService()
        ReferenceService.instance = ref
        _ = ref.getAllReferenceData()
        
        state = GameStateService()
        api = MainAPIService(ref: ref)
        login = LoginService(api: api,state:state)
        activity = ActivityService(api: api, state: state)
        avatar = AvatarService(api: api, state: state)
        user = UserService(api: api, state: state)
        map = MapService(ref:ref)
    }
    
}
