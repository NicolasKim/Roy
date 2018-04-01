//
//  UserPluginDelegate.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/3/13.
//

import UIKit
import Roy

public class UserPluginDelegate:NSObject, RoyModuleProtocol {
    public let moduleHost: String
    public required init(host: String) {
        moduleHost = host
        super.init()
        _ = self.addRouter(path: "hahaha?c=<number>", task: { params in
            return UINavigationController(rootViewController: UserViewController(param: params)!)
        }, paramValidator: nil)
    }
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    public static func host() -> String {
        return "user"
    }
    public static func loadModuleMode() -> RoyLoadModuleMode {
        return .Lazily
    }
}
