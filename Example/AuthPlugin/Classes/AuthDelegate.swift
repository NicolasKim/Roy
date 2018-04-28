//
//  UserPluginDelegate.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/3/13.
//

import UIKit
import Roy
import PromiseKit



public class AuthPluginDelegate:NSObject, RoyModuleProtocol {
    public let moduleHost: String
    let gitHubAuth = GitHub()
    let sem = DispatchSemaphore(value: 0)
    public required init(host: String) {
        moduleHost = host
        super.init()
        
        
        firstly {
            return self.addRouter(path: "github/login", paramValidator: nil) { _ in self.gitHubAuth.login() }
        }.then { (module) -> Promise<RoyModuleProtocol> in
            return module.addRouter(path: "github", paramValidator: nil) { (params) -> Promise<Any?>? in
                if let p = params , let code = p["code"] as? String {
                    self.gitHubAuth.didCodeBack(code: code)
                }
                else{
                    self.gitHubAuth.didCodeBack(code: nil)
                }
                return nil
            }
        }.done { _ in
            
        }
    }
    public static func host() -> String {
        return "auth"
    }
    public static func loadModuleMode() -> RoyLoadModuleMode {
        return .Lazily
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        RoyR.global.route(url: url, param: nil, in: nil).done{_ in }
        return true
    }
    
    
    
}
