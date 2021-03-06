//
//  AppDelegate.swift
//  Roy
//
//  Created by jinqiucheng1006@live.cn on 08/10/2017.
//  Copyright (c) 2017 jinqiucheng1006@live.cn. All rights reserved.
//

import UIKit

import Roy
import UserPlugin




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //set scheme
        RoyModuleConfig.sharedInstance.scheme = "test"

        //addModule
        RoyAppDelegate.sharedInstance.addModuleClass(UserPluginDelegate.self, host: "testmodule")

        if let vc = RoyAppDelegate.sharedInstance.module(host: "testmodule")?.viewController(path: "initializeviewcontroller", param: nil){
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = vc
        }
        return RoyAppDelegate.sharedInstance.application(application,didFinishLaunchingWithOptions:launchOptions)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        RoyAppDelegate.sharedInstance.applicationWillResignActive(application)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        RoyAppDelegate.sharedInstance.applicationDidEnterBackground(application)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        RoyAppDelegate.sharedInstance.applicationWillEnterForeground(application)
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        RoyAppDelegate.sharedInstance.applicationDidBecomeActive(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        RoyAppDelegate.sharedInstance.applicationWillTerminate(application)
    }


}

