//  Created by Alexander Skorulis on 13/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class ReferenceService: NetAPIService {
    
    static var instance:ReferenceService!
    
    var skills:SkillsReferenceModel?
    var resources:ResourceListRefModel?
    var items:ItemsReferenceModel?
    var mods:ItemModsResponse?
    
    init() {
        var baseURL:String = ""
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            baseURL = "http://localhost:8811/ref"
        #else
            baseURL = "http://192.168.1.2:8811/ref"
        #endif
        
        super.init(baseURL: baseURL)
    }
    
    func getAllReferenceData() -> Promise<ReferenceService> {
        let calls:[Promise<Void>] =  [getSkills().asVoid(),getResources().asVoid(),getItems().asVoid(),getItemMods().asVoid()]
        return when(fulfilled: calls).then { _ -> ReferenceService in
            print("Got all reference data")
            return self
        }
    }
    
    func getSkills() -> Promise<SkillsReferenceModel> {
        let req = self.request(path: "skills.json")
        let promise:Promise<SkillsReferenceModel> = self.doRequest(req: req)
        _ = promise.then { skills in
            self.skills = skills
        }
        return promise
    }
    
    func getResources() -> Promise<ResourcesRefResponse> {
        let req = self.request(path: "resources.json")
        let promise:Promise<ResourcesRefResponse> = self.doRequest(req: req)
        _ = promise.then { resources in
            self.resources = resources.resources
        }
        return promise
    }
    
    func getItems() -> Promise<ItemReferenceResponse> {
        let req = self.request(path: "items.json")
        let promise:Promise<ItemReferenceResponse> = self.doRequest(req: req)
        _ = promise.then { items in
            self.items = items.items
        }
        return promise
    }
    
    func getItemMods() -> Promise<ItemModsResponse> {
        let req = self.request(path: "itemMods.json")
        let promise:Promise<ItemModsResponse> = self.doRequest(req: req)
        _ = promise.then { response in
            self.mods = response
        }
        return promise
    }
    
    func skill(_ skillId:Int) -> SkillRefModel {
        return skills!.skills.first(where: { (s) -> Bool in
            return s.id == skillId
        })!
    }
    
    func elementResource(_ resourceId:String) -> ResourceRefModel {
        return self.resources!.elemental[resourceId]!
    }
    
    func filledResource(resource:ResourceModel) -> (ResourceModel,ResourceRefModel) {
        return (resource,self.elementResource(resource.resourceId) )
    }
    
    func allElements() -> [SkillRefModel] {
        return self.skills?.elements ?? []
    }
    
    func allTrades() -> [SkillRefModel] {
        return self.skills?.trades ?? []
    }
    
}
