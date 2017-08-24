//
//  TestModuleDelegate.swift
//  TestModule
//
//  Created by 金秋成 on 2017/8/17.
//  Copyright © 2017年 DreamTracer. All rights reserved.
//

import UIKit
import Roy

public class TestModuleDelegate: RoyModule {
    required public init(appScheme: String, host: String) {
        super.init(appScheme: appScheme, host: host)

        _ = self.addRouter(path: "initializeviewcontroller", viewController: TMViewController.self)
        _ = RoyGlobal.instance.addRouter(url: URL(string: "Roy://testmodule/hahaha")!, viewController: FirstViewController.self)
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
}
