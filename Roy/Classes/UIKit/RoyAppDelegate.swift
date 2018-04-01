//
// Created by 金秋成 on 2017/8/10.
//

import UIKit
import CloudKit


open class RoyAppDelegate : NSObject, UIApplicationDelegate,RoyDelegate {

    static public let sharedInstance = RoyAppDelegate()

    fileprivate var moduleMap : [String : RoyModuleProtocol] = [:]
    fileprivate var lazyModuleMap : [String : RoyModuleProtocol.Type] = [:]
    fileprivate var lock = NSLock()
    public override init() {
        super.init()
		RoyR.regist(delegate: self)
    }
    
    
    public func didAnalyzed(url:URL,param:[String:Any]?,error:Error?){
        guard let host = RoyURLAnalyzer.getHost(url: url.absoluteString) else {
            return
        }
        
        lock.lock()
        guard let c = lazyModuleMap[host] else {
            lock.unlock()
            return
        }
        
        self.moduleMap[c.host()] = c.init(host: c.host())
        lazyModuleMap.removeValue(forKey: c.host())
        lock.unlock()
    }
    
    public func addModuleClass(_ moduleClass : RoyModuleProtocol.Type) {
        switch moduleClass.loadModuleMode() {
        case .Immediately:
            let module = moduleClass.init(host: moduleClass.host())
            self.moduleMap[moduleClass.host()] = module
        case .Lazily:
            self.lazyModuleMap[moduleClass.host()] = moduleClass
        }
    }
    
    public func module(host : String) -> RoyModuleProtocol?{
        return self.moduleMap[host]
    }
    
    
    func enumerateMapBool(handle:(RoyModuleProtocol)->Bool) -> Bool {
        for (_,module) in moduleMap {
            if handle(module) {
                return true
            }
        }
        return false
    }
    
    func enumerateMapVoid(handle:(RoyModuleProtocol)->Void) -> Void {
        for (_,module) in moduleMap {
            handle(module)
        }
    }
    
    func enumerateMapViewController(handle:(RoyModuleProtocol)->UIViewController?) -> UIViewController? {
        for (_,module) in moduleMap {
            if let vc = handle(module){
                return vc
            }
        }
        return nil
    }
    
    
    
    public func applicationDidFinishLaunching(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationDidFinishLaunching?(application)
        }
    }

    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool{
        return enumerateMapBool { (module) -> Bool in
            guard let result = module.application?(application, willFinishLaunchingWithOptions: launchOptions) else{
                return true
            }
            return result;
        }
    }

    
    
    
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool{
        return enumerateMapBool { (module) -> Bool in
            guard let result = module.application?(application, didFinishLaunchingWithOptions: launchOptions) else{
                return true
            }
            return result;
        }
    }



    public func applicationDidBecomeActive(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationDidBecomeActive?(application)
        }
    }

    public func applicationWillResignActive(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationWillResignActive?(application)
        }

    }

//    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool{
        return enumerateMapBool { (module) -> Bool in
            guard let result = module.application?(application, handleOpen: url) else{
                return true
            }
            return result;
        }
    }
//
//    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return enumerateMapBool { (module) -> Bool in
            guard let result = module.application?(application, open: url, sourceApplication: sourceApplication, annotation: annotation) else{
                return true
            }
            return result;
        }
    }



    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return RoyR.global.route(url: url, param: nil) as! Bool
    }


    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        enumerateMapVoid { (module) in
            module.applicationDidReceiveMemoryWarning?(application)
        }

    }

    public func applicationWillTerminate(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationWillTerminate?(application)
        }
    }

    public func applicationSignificantTimeChange(_ application: UIApplication) {
        enumerateMapVoid { (module) in
            module.applicationSignificantTimeChange?(application)
        }
    }


    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval){
        enumerateMapVoid { (module) in
            module.application?(application, willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)
        }
    }

    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation){
        enumerateMapVoid { (module) in
            module.application?(application, didChangeStatusBarOrientation: oldStatusBarOrientation)
        }
    }


    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        enumerateMapVoid { (module) in
            module.application?(application, willChangeStatusBarFrame: newStatusBarFrame)
        }
    }

    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect){
        enumerateMapVoid { (module) in
            module.application?(application, didChangeStatusBarFrame: oldStatusBarFrame)
        }
    }


    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings){
        enumerateMapVoid { (module) in
            module.application?(application, didRegister: notificationSettings)
        }
    }


    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        enumerateMapVoid { (module) in
            module.application?(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }

    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        enumerateMapVoid { (module) in
            module.application?(application, didFailToRegisterForRemoteNotificationsWithError: error)
        }

    }


//    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        enumerateMapVoid { (module) in
            module.application?(application, didReceiveRemoteNotification: userInfo)
        }
    }
//
//
//    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, didReceive notification: UILocalNotification){
        enumerateMapVoid { (module) in
            module.application?(application, didReceive: notification)
        }
    }


    // Called when your app has been activated by the user selecting an action from a local notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
//    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Swift.Void){
        enumerateMapVoid { (module) in
            module.application?(application, handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler)
        }
    }


//    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){
        enumerateMapVoid { (module) in
            if #available(iOS 9.0, *) {
                module.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
            } else {
                // Fallback on earlier versions
            }
        }
    }


    // Called when your app has been activated by the user selecting an action from a remote notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
//    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){
        enumerateMapVoid { (module) in
            module.application?(application, handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }


//    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){
        enumerateMapVoid { (module) in
            if #available(iOS 9.0, *) {
                module.application?(application, handleActionWithIdentifier: identifier, for: notification, withResponseInfo: responseInfo, completionHandler: completionHandler)
            } else {
                // Fallback on earlier versions
            }
        }

    }


    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.

     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
        enumerateMapVoid { (module) in
            module.application?(application, didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }


    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
        enumerateMapVoid { (module) in
            module.application?(application, performFetchWithCompletionHandler: completionHandler)
        }
    }


    @available(iOS 9.0, *)
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void){
        enumerateMapVoid { (module) in
            module.application?(application, performActionFor: shortcutItem, completionHandler: completionHandler)
        }

    }


    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void){
        enumerateMapVoid { (module) in
            module.application?(application, handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
        }

    }


    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Swift.Void){
        enumerateMapVoid { (module) in
            if #available(iOS 8.2, *) {
                module.application?(application, handleWatchKitExtensionRequest: userInfo, reply: reply)
            } else {
                // Fallback on earlier versions
            }
        }
    }


    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication){
        enumerateMapVoid { (module) in
            if #available(iOS 9.0, *) {
                module.applicationShouldRequestHealthAuthorization?(application)
            } else {
                // Fallback on earlier versions
            }
        }
    }


    public func applicationDidEnterBackground(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationDidEnterBackground?(application)
        }
    }

    public func applicationWillEnterForeground(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationWillEnterForeground?(application)
        }
    }


    public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationProtectedDataWillBecomeUnavailable?(application)
        }
    }

    public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication){
        enumerateMapVoid { (module) in
            module.applicationProtectedDataDidBecomeAvailable?(application)
        }
    }


    public var window: UIWindow?


    public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }


    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool{
        return enumerateMapBool(handle: { (module) -> Bool in
            guard let result = module.application?(application, shouldAllowExtensionPointIdentifier: extensionPointIdentifier) else{
                return true
            }
            return result
        })
    }


    public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController?{
        return enumerateMapViewController(handle: { (module) -> UIViewController? in
            return module.application?(application, viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder)
        })
    }

    public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool{
        return enumerateMapBool(handle: { (module) -> Bool in
            guard let result = module.application?(application, shouldSaveApplicationState: coder) else{
                return true
            }
            return result
        })
    }

    public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool{
        return enumerateMapBool(handle: { (module) -> Bool in
            guard let result = module.application?(application, shouldRestoreApplicationState: coder) else{
                return true
            }
            return result
        })
    }

    public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder){
        enumerateMapVoid { (module) in
            module.application?(application, willEncodeRestorableStateWith: coder)
        }
    }

    public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder){
        enumerateMapVoid { (module) in
            module.application?(application, didDecodeRestorableStateWith: coder)
        }
    }


    public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool{

        return enumerateMapBool(handle: { (module) -> Bool in
            guard let result = module.application?(application, willContinueUserActivityWithType: userActivityType) else{
                return true
            }
            return result
        })
    }


    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool{

        return enumerateMapBool(handle: { (module) -> Bool in
            guard let result = module.application?(application, continue: userActivity, restorationHandler: restorationHandler) else{
                return true
            }
            return result
        })
    }


    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error){
        enumerateMapVoid { (module) in
            module.application?(application, didFailToContinueUserActivityWithType: userActivityType, error: error)
        }
    }


    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity){
        enumerateMapVoid { (module) in
            module.application?(application, didUpdate: userActivity)
        }
    }


    @available(iOS 10.0, *)
    public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata){
        enumerateMapVoid { (module) in
            module.application?(application, userDidAcceptCloudKitShareWith: cloudKitShareMetadata)
        }
    }
}
