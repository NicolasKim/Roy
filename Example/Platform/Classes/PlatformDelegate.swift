//
//  UserPluginDelegate.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/3/13.
//

import UIKit
import Roy



public class PlatformDelegate:NSObject, RoyModuleProtocol {
    public let moduleHost: String
    public required init(host: String) {
        moduleHost = host
        super.init()
    }
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let rootViewController = TMViewController(param: nil)
        application.delegate?.window??.rootViewController = rootViewController
        return true
    }
    public static func host() -> String {
        return "platform"
    }
    public static func loadModuleMode() -> RoyLoadModuleMode {
        return .Immediately
    }
}
