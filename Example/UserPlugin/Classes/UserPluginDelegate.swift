//
//  UserPluginDelegate.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/3/13.
//

import UIKit
import Roy
import PromiseKit

public class UserPluginDelegate:NSObject, RoyModuleProtocol {
    public let moduleHost: String
    public required init(host: String) {
        moduleHost = host
        super.init()
        self.addRouter(path: "main?c=<number>", paramValidator: nil) { params in
            return Promise<Any?>{ seal in
                seal.fulfill(UINavigationController(rootViewController: UserViewController(param: params)!))
            }
        }.done{ _ in

        }
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
