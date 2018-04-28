//
//  RoyExtension-iOS.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/4/28.
//

import Foundation
import CloudKit
import Intents


extension RoyModuleProtocol{
    @available(iOS 2.0, *)
    func moduleDidFinishLaunching() {}
    
    @available(iOS 6.0, *)
    func module(willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool { return false }
    
    @available(iOS 3.0, *)
    func module(didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool { return false }
    
    @available(iOS 2.0, *)
    func moduleDidBecomeActive(){}
    
    @available(iOS 2.0, *)
    func moduleWillResignActive(){}
    
    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use module:openURL:options:")
    func module(handleOpen url: URL) -> Bool { return false }
    
    
    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use module:openURL:options:")
    public func module(open url: URL, sourceApplication: String?, annotation: Any) -> Bool{ return false }
    
    
    @available(iOS 9.0, *)
    public func module(open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool { return true }
    
    
    @available(iOS 2.0, *)
    public func moduleDidReceiveMemoryWarning() { }
    
    @available(iOS 2.0, *)
    public func moduleWillTerminate(){ }
    
    @available(iOS 2.0, *)
    public func moduleSignificantTimeChange() { }
    
    
    @available(iOS 2.0, *)
    public func module(willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval){ }
    
    @available(iOS 2.0, *)
    public func module(didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation){ }
    
    
    @available(iOS 2.0, *)
    public func module(willChangeStatusBarFrame newStatusBarFrame: CGRect) { }
    
    @available(iOS 2.0, *)
    public func module(didChangeStatusBarFrame oldStatusBarFrame: CGRect){ }
    
    
    // This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    public func module(didRegister notificationSettings: UIUserNotificationSettings){ }
   
    @available(iOS 3.0, *)
    public func module(didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){ }
    
    
    @available(iOS 3.0, *)
    public func module(didFailToRegisterForRemoteNotificationsWithError error: Error){ }
	
    
    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    public func module(didReceiveRemoteNotification userInfo: [AnyHashable : Any]){ }
    
    
    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func module(didReceive notification: UILocalNotification){ }
    
    
    // Called when your app has been activated by the user selecting an action from a local notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func module(handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Swift.Void){ }
    
    
    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func module(handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){ }
    
    
    // Called when your app has been activated by the user selecting an action from a remote notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func module(handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){ }
    
    
    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func module(handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){ }
    
    
    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    @available(iOS 7.0, *)
    public func module(didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){ }
    
    
    /// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
    @available(iOS 7.0, *)
    public func module(performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){ }
    
    
    // Called when the user activates your application by selecting a shortcut on the home screen,
    // except when -application:willFinishLaunchingWithOptions: or -application:didFinishLaunchingWithOptions returns NO.
    @available(iOS 9.0, *)
    public func module(performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void){ }
    
    
    // Applications using an NSURLSession with a background configuration may be launched or resumed in the background in order to handle the
    // completion of tasks in that session, or to handle authentication. This method will be called with the identifier of the session needing
    // attention. Once a session has been created from a configuration object with that identifier, the session's delegate will begin receiving
    // callbacks. If such a session has already been created (if the app is being resumed, for instance), then the delegate will start receiving
    // callbacks without any action by the application. You should call the completionHandler as soon as you're finished handling the callbacks.
    @available(iOS 7.0, *)
    public func module(handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void){ }
    
    
    @available(iOS 8.2, *)
    public func module(handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Swift.Void){ }
    
    
    @available(iOS 9.0, *)
    public func moduleShouldRequestHealthAuthorization(){ }
    
    
    @available(iOS 11.0, *)
    public func module(handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Swift.Void){ }
    
    
    @available(iOS 4.0, *)
    public func moduleDidEnterBackground(){ }
    
    @available(iOS 4.0, *)
    public func moduleWillEnterForeground(){ }
    
    
    @available(iOS 4.0, *)
    public func moduleProtectedDataWillBecomeUnavailable(){ }
    
    @available(iOS 4.0, *)
    public func moduleProtectedDataDidBecomeAvailable(){ }
    
    
    //    @available(iOS 5.0, *)
    //    public var window: UIWindow? { get set }
    
    
    @available(iOS 6.0, *)
    public func module(supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{ return .all }
    
    
    // Applications may reject specific types of extensions based on the extension point identifier.
    // Constants representing common extension point identifiers are provided further down.
    // If unimplemented, the default behavior is to allow the extension point identifier.
    @available(iOS 8.0, *)
    public func module(shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool{ return false }
    
    
    @available(iOS 6.0, *)
    public func module(viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController?{ return nil }
    
    @available(iOS 6.0, *)
    public func module(shouldSaveApplicationState coder: NSCoder) -> Bool{ return false }
    
    @available(iOS 6.0, *)
    public func module(shouldRestoreApplicationState coder: NSCoder) -> Bool{ return false }
    
    @available(iOS 6.0, *)
    public func module(willEncodeRestorableStateWith coder: NSCoder){ }
    
    @available(iOS 6.0, *)
    public func module(didDecodeRestorableStateWith coder: NSCoder){ }
    
    
    // Called on the main thread as soon as the user indicates they want to continue an activity in your application. The NSUserActivity object may not be available instantly,
    // so use this as an opportunity to show the user that an activity will be continued shortly.
    // For each application:willContinueUserActivityWithType: invocation, you are guaranteed to get exactly one invocation of application:continueUserActivity: on success,
    // or application:didFailToContinueUserActivityWithType:error: if an error was encountered.
    @available(iOS 8.0, *)
    public func module(willContinueUserActivityWithType userActivityType: String) -> Bool{ return false }
    
    
    // Called on the main thread after the NSUserActivity object is available. Use the data you stored in the NSUserActivity object to re-create what the user was doing.
    // You can create/fetch any restorable objects associated with the user activity, and pass them to the restorationHandler. They will then have the UIResponder restoreUserActivityState: method
    // invoked with the user activity. Invoking the restorationHandler is optional. It may be copied and invoked later, and it will bounce to the main thread to complete its work and call
    // restoreUserActivityState on all objects.
    @available(iOS 8.0, *)
    public func module(continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool{ return false }
    
    
    // If the user activity cannot be fetched after willContinueUserActivityWithType is called, this will be called on the main thread when implemented.
    @available(iOS 8.0, *)
    public func module(didFailToContinueUserActivityWithType userActivityType: String, error: Error){ }
    
    
    // This is called on the main thread when a user activity managed by UIKit has been updated. You can use this as a last chance to add additional data to the userActivity.
    @available(iOS 8.0, *)
    public func module(didUpdate userActivity: NSUserActivity){ }
    
    
    // This will be called on the main thread after the user indicates they want to accept a CloudKit sharing invitation in your application.
    // You should use the CKShareMetadata object's shareURL and containerIdentifier to schedule a CKAcceptSharesOperation, then start using
    // the resulting CKShare and its associated record(s), which will appear in the CKContainer's shared database in a zone matching that of the record's owner.
    @available(iOS 10.0, *)
    public func module(userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata){ }
    
}




extension RoyModuleManager : UIApplicationDelegate{
    
    @available(iOS 2.0, *)
    public func applicationDidFinishLaunching(_ application: UIApplication){
        self.enumerate { (module) in
        	module.moduleDidFinishLaunching()
        }
    }
    
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff, callback: { (module) -> Bool in
            return module.module(willFinishLaunchingWithOptions: launchOptions)
        })
    }
    
    @available(iOS 3.0, *)
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff, callback: { (module) -> Bool in
            return module.module(didFinishLaunchingWithOptions: launchOptions)
        })
    }
    
    
    @available(iOS 2.0, *)
    public func applicationDidBecomeActive(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleDidBecomeActive()
        }
    }
    
    @available(iOS 2.0, *)
    public func applicationWillResignActive(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleWillResignActive()
        }
    }
    
    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
    public func application(_ application: UIApplication, handleOpen url: URL) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff, callback: { (module) -> Bool in
            module.module(handleOpen: url)
        })
    }
    
    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
    public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff, callback: { (module) -> Bool in
            return module.module(open: url, sourceApplication: sourceApplication, annotation: annotation)
        })
    }
    
    
    @available(iOS 9.0, *)
    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff, callback: { (module) -> Bool in
            return module.module(open: url, options: options)
        })
    }
    
    
    @available(iOS 2.0, *)
    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        self.enumerate { (module) in
            module.moduleDidReceiveMemoryWarning()
        }
    }
    
    @available(iOS 2.0, *)
    public func applicationWillTerminate(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleWillTerminate()
        }
    }
    
    @available(iOS 2.0, *)
    public func applicationSignificantTimeChange(_ application: UIApplication) {
        self.enumerate { (module) in
            module.moduleSignificantTimeChange()
        }
    }
    
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval){
        self.enumerate { (module) in
            module.module(willChangeStatusBarOrientation: newStatusBarOrientation, duration: duration)
        }
    }
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation){
        self.enumerate { (module) in
            module.module(didChangeStatusBarOrientation: oldStatusBarOrientation)
        }
    }
    
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {
        self.enumerate { (module) in
            module.module(willChangeStatusBarFrame: newStatusBarFrame)
        }
    }
    
    @available(iOS 2.0, *)
    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect){
        self.enumerate { (module) in
            module.module(didChangeStatusBarFrame: oldStatusBarFrame)
        }
    }
    
    
    // This callback will be made upon calling -[UIApplication registerUserNotificationSettings:]. The settings the user has granted to the application will be passed in as the second argument.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenter requestAuthorizationWithOptions:completionHandler:]")
    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings){
        self.enumerate { (module) in
            module.module(didRegister: notificationSettings)
        }
    }
    
    
    @available(iOS 3.0, *)
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        self.enumerate { (module) in
            module.module(didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    
    @available(iOS 3.0, *)
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){
        self.enumerate { (module) in
            module.module(didFailToRegisterForRemoteNotificationsWithError: error)
        }
    }
    
    
    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){
        self.enumerate { (module) in
            module.module(didReceiveRemoteNotification: userInfo)
        }
    }
    
    
    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, didReceive notification: UILocalNotification){
        self.enumerate { (module) in
            module.module(didReceive: notification)
        }
    }
    
    
    // Called when your app has been activated by the user selecting an action from a local notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Swift.Void){
        self.enumerate { (module) in
            module.module(handleActionWithIdentifier: identifier, for: notification, completionHandler: completionHandler)
        }
    }
    
    
    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){
        self.enumerate { (module) in
            module.module(handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }
    
    
    // Called when your app has been activated by the user selecting an action from a remote notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){
        self.enumerate { (module) in
            module.module(handleActionWithIdentifier: identifier, forRemoteNotification: userInfo, completionHandler: completionHandler)
        }
    }
    
    
    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
    public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void){
        self.enumerate { (module) in
            module.module(handleActionWithIdentifier: identifier, for: notification, withResponseInfo: responseInfo, completionHandler: completionHandler)
        }
    }
    
    
    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
     
     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    @available(iOS 7.0, *)
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
        self.enumerate { (module) in
            module.module(didReceiveRemoteNotification: userInfo, fetchCompletionHandler: completionHandler)
        }
    }
    
    
    /// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
    @available(iOS 7.0, *)
    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){
        self.enumerate { (module) in
            module.module(performFetchWithCompletionHandler: completionHandler)
        }
    }
    
    
    // Called when the user activates your application by selecting a shortcut on the home screen,
    // except when -application:willFinishLaunchingWithOptions: or -application:didFinishLaunchingWithOptions returns NO.
    @available(iOS 9.0, *)
    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void){
        self.enumerate { (module) in
            module.module(performActionFor: shortcutItem, completionHandler: completionHandler)
        }
    }
    
    
    // Applications using an NSURLSession with a background configuration may be launched or resumed in the background in order to handle the
    // completion of tasks in that session, or to handle authentication. This method will be called with the identifier of the session needing
    // attention. Once a session has been created from a configuration object with that identifier, the session's delegate will begin receiving
    // callbacks. If such a session has already been created (if the app is being resumed, for instance), then the delegate will start receiving
    // callbacks without any action by the application. You should call the completionHandler as soon as you're finished handling the callbacks.
    @available(iOS 7.0, *)
    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void){
        self.enumerate { (module) in
            module.module(handleEventsForBackgroundURLSession: identifier, completionHandler: completionHandler)
        }
    }
    
    
    @available(iOS 8.2, *)
    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Swift.Void){
        self.enumerate { (module) in
            module.module(handleWatchKitExtensionRequest: userInfo, reply: reply)
        }
    }
    
    
    @available(iOS 9.0, *)
    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleShouldRequestHealthAuthorization()
        }
    }
    
    
    @available(iOS 11.0, *)
    public func application(_ application: UIApplication, handle intent: INIntent, completionHandler: @escaping (INIntentResponse) -> Swift.Void){
        self.enumerate { (module) in
            module.module(handle: intent, completionHandler: completionHandler)
        }
    }
    
    
    @available(iOS 4.0, *)
    public func applicationDidEnterBackground(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleDidEnterBackground()
        }
    }
    
    @available(iOS 4.0, *)
    public func applicationWillEnterForeground(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleWillEnterForeground()
        }
    }
    
    
    @available(iOS 4.0, *)
    public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleProtectedDataWillBecomeUnavailable()
        }
    }
    
    @available(iOS 4.0, *)
    public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication){
        self.enumerate { (module) in
            module.moduleProtectedDataDidBecomeAvailable()
        }
    }
    
    
    //    @available(iOS 5.0, *)
    //    public var window: UIWindow? { get set }
    
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        return self.enumerate(defaultValue: UIInterfaceOrientationMask.all, callback: { module  in
            return module.module(supportedInterfaceOrientationsFor: window)
        })
    }
    
    
    // Applications may reject specific types of extensions based on the extension point identifier.
    // Constants representing common extension point identifiers are provided further down.
    // If unimplemented, the default behavior is to allow the extension point identifier.
    @available(iOS 8.0, *)
    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff) { (module) -> Bool in
            return module.module(shouldAllowExtensionPointIdentifier: extensionPointIdentifier)
        }
    }
    
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController?{
        return self.enumerate(defaultValue: nil, callback: { (module) -> UIViewController? in
            return module.module(viewControllerWithRestorationIdentifierPath: identifierComponents, coder: coder)
        })
    }
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff) { (module) -> Bool in
            return module.module(shouldSaveApplicationState: coder)
        }
    }
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff) { (module) -> Bool in
            return module.module(shouldRestoreApplicationState: coder)
        }
    }
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder){
        self.enumerate { (module) in
            module.module(willEncodeRestorableStateWith: coder)
        }
    }
    
    @available(iOS 6.0, *)
    public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder){
        self.enumerate { (module) in
            module.module(didDecodeRestorableStateWith: coder)
        }
    }
    
    
    // Called on the main thread as soon as the user indicates they want to continue an activity in your application. The NSUserActivity object may not be available instantly,
    // so use this as an opportunity to show the user that an activity will be continued shortly.
    // For each application:willContinueUserActivityWithType: invocation, you are guaranteed to get exactly one invocation of application:continueUserActivity: on success,
    // or application:didFailToContinueUserActivityWithType:error: if an error was encountered.
    @available(iOS 8.0, *)
    public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff) { (module) -> Bool in
            return module.module(willContinueUserActivityWithType: userActivityType)
        }
    }
    
    
    // Called on the main thread after the NSUserActivity object is available. Use the data you stored in the NSUserActivity object to re-create what the user was doing.
    // You can create/fetch any restorable objects associated with the user activity, and pass them to the restorationHandler. They will then have the UIResponder restoreUserActivityState: method
    // invoked with the user activity. Invoking the restorationHandler is optional. It may be copied and invoked later, and it will bounce to the main thread to complete its work and call
    // restoreUserActivityState on all objects.
    @available(iOS 8.0, *)
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool{
        return self.enumerate(type: RoyModuleManager.RoyModuleEnum.Diff) { (module) -> Bool in
            return module.module(continue: userActivity, restorationHandler: restorationHandler)
        }
    }
    
    
    // If the user activity cannot be fetched after willContinueUserActivityWithType is called, this will be called on the main thread when implemented.
    @available(iOS 8.0, *)
    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error){
        self.enumerate { (module) in
            module.module(didFailToContinueUserActivityWithType: userActivityType, error: error)
        }
    }
    
    
    // This is called on the main thread when a user activity managed by UIKit has been updated. You can use this as a last chance to add additional data to the userActivity.
    @available(iOS 8.0, *)
    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity){
        self.enumerate { (module) in
            module.module(didUpdate: userActivity)
        }
    }
    
    
    // This will be called on the main thread after the user indicates they want to accept a CloudKit sharing invitation in your application.
    // You should use the CKShareMetadata object's shareURL and containerIdentifier to schedule a CKAcceptSharesOperation, then start using
    // the resulting CKShare and its associated record(s), which will appear in the CKContainer's shared database in a zone matching that of the record's owner.
    @available(iOS 10.0, *)
    public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata){
        self.enumerate { (module) in
            module.module(userDidAcceptCloudKitShareWith: cloudKitShareMetadata)
        }
    }
}
