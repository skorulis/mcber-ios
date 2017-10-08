//  Created by Alexander Skorulis on 12/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import ObjectMapper

class ResourceModel: ImmutableMappable, ReferenceFillable {
    
    var quantity:Int
    let resourceId:String
    
    var refModel:ResourceRefModel!
    
    required init(map: Map) throws {
        quantity = try map.value("quantity")
        resourceId = try map.value("id")
    }
    
    init(quantity:Int,resourceId:String) {
        self.quantity = quantity
        self.resourceId = resourceId
    }
    
    func fill(ref: ReferenceService) {
        self.refModel = ref.elementResource(self.resourceId)
        assert(self.refModel != nil)
    }
    
}

class UserModel: ImmutableMappable, ReferenceFillable {

    let _id:String
    let email:String?
    var avatars:[AvatarModel]
    var realms:[RealmModel]
    var activities:[ActivityModel]
    var currency:Int
    
    let resources:MonitoredArray<ResourceModel>
    let items:MonitoredArray<ItemModel>
    let gems:MonitoredArray<ItemGemModel>
    
    required init(map: Map) throws {
        let resourcesArray:[ResourceModel] = try map.value("resources");
        let itemsArray:[ItemModel] = try map.value("items")
        let gemsArray:[ItemGemModel] = try map.value("gems")
        
        _id = try map.value("_id")
        email = try? map.value("email")
        avatars = try map.value("avatars")
        realms = try map.value("realms")
        activities = try map.value("activities")
        currency = try map.value("currency")
        
        self.resources = MonitoredArray(array: resourcesArray)
        self.items = MonitoredArray(array: itemsArray)
        self.gems = MonitoredArray(array: gemsArray)
    }
    
    func fill(ref: ReferenceService) {
        resources.forEach { $0.fill(ref: ref) }
        realms.forEach { $0.fill(ref: ref) }
        activities.forEach { $0.fill(ref: ref) }
        avatars.forEach { $0.fill(ref: ref) }
        items.forEach { $0.fill(ref: ref) }
        gems.forEach { $0.fill(ref: ref) }
    }
    
    func itemsForSlot(slot:ItemSlotRef) -> [ItemModel] {
        return items.array.filter { slot.types.contains($0.type) }
    }
    
    func hasResource(resource:ResourceModel) -> Bool {
        if let index = resources.index(where: { $0.resourceId == resource.resourceId }) {
            return resources[index].quantity >= resource.quantity
        }
        return false
    }
}

class UserResponse: ImmutableMappable, ReferenceFillable {
    
    let user:UserModel
    
    required init(map: Map) throws {
        user = try map.value("user")
    }
    
    func fill(ref: ReferenceService) {
        user.fill(ref: ref)
    }
}
