//
//  UserPluginDelegate.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/3/13.
//

import UIKit
import Roy



public class AuthPluginDelegate:NSObject, RoyModuleProtocol {
    public let moduleHost: String
    let gitHubAuth = GitHub()
    public required init(host: String) {
        moduleHost = host
        super.init()
        
        _ = self.addRouter(
            path: "github/login",
            task: { (params) -> Any? in
                if let p = params, let callback = p["callback"] as? (_ userInfo:Dictionary<String,Any>?,_ error:Error?)->Void {
                	self.gitHubAuth.login(callback: callback)
                }
                return nil
        	},
            paramValidator: nil)
        
        
        _ = self.addRouter(
            	path: "github",
            	task: { (params) -> Any? in
            		if let p = params , let code = p["code"] as? String {
                        self.gitHubAuth.getAccessToken(code: code, callback: { (token, error) in
                            print(token,error)
                        })
                    }
                    return true
        		},
            	paramValidator: nil)
    }
    public static func host() -> String {
        return "auth"
    }
    public static func loadModuleMode() -> RoyLoadModuleMode {
        return .Lazily
    }
    
//    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        _ = RoyR.global.route(url: url, param: nil)
//        return true
//    }
    
}
