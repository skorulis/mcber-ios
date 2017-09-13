//  Created by Alexander Skorulis on 16/12/16.
//  Copyright © 2016 Alexander Skorulis. All rights reserved.

import UIKit
import ObjectMapper
import PromiseKit

extension URL {
    
    func appendQuery(query:String) -> URL? {
        let all = self.absoluteString
        let sep = all.contains("?") ? "&" : "?"
        let changed = String(format: "%@%@%@", all,sep,query)
        return URL(string: changed)
    }
    
}

public protocol NetAPITokenWriter: class {
    
    var bearerToken:String? { get }
    var bearerExpiry:Double? { get }
    func saveToken(token:String?,expiry:Double?)
    
}

public class NetAPIService: NSObject {

    
    
    let baseURL:String?
    let session:URLSession
    var activeRequests = [URLRequest:URLDataPromise]()
    var tokenWriter: NetAPITokenWriter?
    
    public init(baseURL:String?) {
        let config = URLSessionConfiguration.default
        self.baseURL = baseURL
        self.session = URLSession(configuration: config)
    }
    
    public func urlForPath(path:String) -> URL? {
        if let b = baseURL {
            return URL(string:b)?.appendingPathComponent(path)
        } else {
            return URL(string: path)
        }
    }
    
    public func urlForPath(path:String,query:String) -> URL? {
        return urlForPath(path: path)?.appendQuery(query: query)
    }
    
    public func urlForPath(path:String,queryParams:[String:String]) -> URL? {
        return queryParams.reduce(urlForPath(path: path), { (result, p:(key: String, value: String)) -> URL? in
            return result?.appendQuery(query: String(format: "%@=%@", p.key,p.value))
        })
    }
    
    public func request(path:String) -> URLRequest {
        var req = URLRequest(url: self.urlForPath(path: path)!)
        req.httpMethod = "GET"
        return req
    }
    
    public func jsonPostRequest(path:String,dict:[String:Any?]) -> URLRequest {
        var req = request(path: path)
        req.httpMethod = "POST"
        req.httpBody = data(dict: dict)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
    
    public func formPostRequst(path:String,dict:[String:Any]) -> URLRequest {
        var req = request(path: path)
        req.httpMethod = "POST"
        req.httpBody = data(dict: dict)
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return req
    }
    
    public func jsonPostRequest(path:String,obj:BaseMappable) -> URLRequest {
        return jsonPostRequest(path: path,dict: obj.toJSON())
    }
    
    public func data(dict:[String:Any?]) -> Data? {
        do {
            return try JSONSerialization.data(withJSONObject: dict, options: [])
        } catch {
            print("error creating JSON data \(error)")
        }
        return nil
    }
    
    public func matching(req:URLRequest) -> URLDataPromise? {
        return self.activeRequests[req]
    }
    
    public func dataPromise(req:URLRequest) -> URLDataPromise {
        var p:URLDataPromise? = matching(req: req)
        if p == nil {
            p = self.session.dataTask(with: req)
            self.activeRequests[req] = p
            p?.always {
                self.activeRequests.removeValue(forKey: req)
            }
        }
        return p!
    }
    
    public func doRequest<T: BaseMappable>(req:URLRequest) -> Promise<T> {
        let p = dataPromise(req: req)
        return self.handleResponse(dataPromise: p)
    }
    
    public func handleResponse<T: BaseMappable>(dataPromise:URLDataPromise) -> Promise<T> {
        return dataPromise.then {[unowned self] data -> Promise<T> in
            return self.parseData(data: data, connectionError: nil)
        }
    }
    
    public func parseData<T: BaseMappable>(data:Data?,connectionError:Error?) -> Promise<T> {
        do {
            if let d = data {
                let json = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as! [String:Any]
                let result:T? = Mapper(context: nil).map(JSON: json)
                print("Got response \(String(describing: result))")
                if let r = result {
                    return Promise(value: r)
                } else {
                    let error = NSError(domain: "net", code: 34, userInfo: [:])
                    return Promise(error: error)
                }
            } else {
                print("Connection error \(String(describing: connectionError))")
                return Promise(error: connectionError!)
            }
        } catch let error as NSError {
            print("Details of JSON parsing error:\n \(error)")
            return Promise(error: error)
        }
    }

    
}
