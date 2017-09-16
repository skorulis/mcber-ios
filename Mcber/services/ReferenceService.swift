//  Created by Alexander Skorulis on 13/9/17.
//  Copyright © 2017 Alex Skorulis. All rights reserved.

import UIKit
import PromiseKit

class ReferenceService: NetAPIService {
    
    static var instance:ReferenceService!
    
    var skills:SkillsReferenceModel?
    var resources:ResourceListRefModel?
    
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
        let calls:[Promise<Void>] =  [getSkills().asVoid(),getResources().asVoid()]
        return when(fulfilled: calls).then { _ -> ReferenceService in
            print("Got all reference data")
            return self
        }
    }
    
    func getSkills() -> Promise<SkillsRefResponse> {
        let req = self.request(path: "skills.json")
        let promise:Promise<SkillsRefResponse> = self.doRequest(req: req)
        _ = promise.then { skills in
            self.skills = skills.skills
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
    
    func element(_ elementId:Int) -> SkillModel {
        return self.skills!.elements[elementId]
    }
    
    func trade(_ tradeId:Int) -> SkillModel {
        return self.skills!.trades[tradeId]
    }
    
    func skill(_ skillId:Int,type:SkillType) -> SkillModel {
        switch(type) {
        case .element:
            return element(skillId)
        case .trade:
            return trade(skillId)
        }
    }
    
    
    func elementResource(_ resourceId:String) -> ResourceRefModel {
        return self.resources!.elemental[resourceId]!
    }
    
    func filledResource(resource:ResourceModel) -> (ResourceModel,ResourceRefModel) {
        return (resource,self.elementResource(resource.resourceId) )
    }
    
    func filledSkill(progress:SkillProgressModel) -> (SkillProgressModel, SkillModel) {
        let skill = self.skill(progress.skillId, type: progress.type)
        return (progress, skill)
    }
    
    func allElements() -> [SkillModel] {
        return self.skills?.elements ?? []
    }
    
    func allTrades() -> [SkillModel] {
        return self.skills?.trades ?? []
    }
    
}
