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

class UserOptionModel: ImmutableMappable {
    
    let optionName:String
    var optionValue:Any
    
    required init(map: Map) throws {
        optionName = try map.value("optionName")
        optionValue = try map.value("optionValue")
    }
    
    init(optionName:String,optionValue:Any) {
        self.optionName = optionName;
        self.optionValue = optionValue
    }
    
}

class UserModel: ImmutableMappable, ReferenceFillable {

    let _id:String
    let email:String?
    var avatars:[AvatarModel]
    var realms:[RealmModel]
    var activities:[ActivityModel]
    var currency:Int
    let maxAvatars:Int
    
    var resources:[ResourceModel]
    var items:[ItemModel]
    var gems:[ItemGemModel]
    var options:[UserOptionModel];
    
    required init(map: Map) throws {
        _id = try map.value("_id")
        email = try? map.value("email")
        avatars = try map.value("avatars")
        realms = try map.value("realms")
        activities = try map.value("activities")
        currency = try map.value("currency")
        
        maxAvatars = try map.value("maxAvatars")
        
        self.resources = try map.value("resources");
        self.items = try map.value("items")
        self.gems = try map.value("gems")
        self.options = try map.value("options")
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
        return items.filter { slot.types.contains($0.type) }
    }
    
    func hasResource(resource:ResourceModel) -> Bool {
        if let index = resources.index(where: { $0.resourceId == resource.resourceId }) {
            return resources[index].quantity >= resource.quantity
        }
        return false
    }
    
    func getOption(name:String) -> Any? {
        return self.options.first { $0.optionName == name }?.optionValue
    }
    
    func setOption(name:String,value:Any) {
        let existing = self.options.first{ $0.optionName == name }
        if existing != nil {
            existing?.optionValue = value
        } else {
            options.append(UserOptionModel(optionName: name, optionValue: value))
        }
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
