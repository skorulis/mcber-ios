//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class AvatarService: NSObject {

    let api:MainAPIService
    let state:GameStateService
    
    init(api:MainAPIService,state:GameStateService) {
        self.api = api
        self.state = state
        super.init()
    }
    
    func assignItem(item:ItemModel?,slot:ItemSlotRef,avatar:AvatarModel) -> Promise<AssignItemResponse>  {
        let promise:Promise<AssignItemResponse> = self.api.assignItem(itemId: item?._id, slot: slot.id, avatarId: avatar._id)
        _ = promise.then { response -> Void in
            self.state.update(avatar: response.avatar)
            if let oldItem = response.removedItem {
                self.state.add(item: oldItem)
            }
            if let item = item {
                self.state.remove(item: item)
            }
        }
        return promise
    }
    
}
