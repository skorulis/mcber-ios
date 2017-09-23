//  Created by Alexander Skorulis on 23/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class AssignItemResponse: ImmutableMappable, ReferenceFillable {

    let avatar:AvatarModel
    let removedItem:ItemModel?
    
    required init(map: Map) throws {
        avatar = try map.value("avatar")
        removedItem = try? map.value("removedItem")
    }
    
    func fill(ref:ReferenceService) {
        avatar.fill(ref: ref)
        removedItem?.fill(ref: ref)
    }
    
}
