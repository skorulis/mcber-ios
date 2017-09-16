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
    
    func element(_ elementId:Int) -> ElementalSkillModel {
        return self.skills!.elements[elementId]
    }
    
    func elementResource(_ resourceId:String) -> ResourceRefModel {
        return self.resources!.elemental[resourceId]!
    }
    
    func allElements() -> [ElementalSkillModel] {
        return self.skills?.elements ?? []
    }
    
}
