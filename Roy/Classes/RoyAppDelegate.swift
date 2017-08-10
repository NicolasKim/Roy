//
// Created by 金秋成 on 2017/8/10.
//

import UIKit



class RoyAppDelegate : NSObject, UIApplicationDelegate {

    static let sharedInstance = RoyAppDelegate()

    fileprivate var moduleMap : [String : RoyModuleProtocol] = [:]

    var appScheme : String = "Roy"

    public func addModule(module : RoyModuleProtocol) {
        self.moduleMap[module.identifier] = module
    }

    public func applicationDidFinishLaunching(_ application: UIApplication){
        for (_,module) in moduleMap {
            module.applicationDidFinishLaunching?(application)
        }
    }

    public func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool{

        return true
    }

    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool{

        return true
    }



    public func applicationDidBecomeActive(_ application: UIApplication){


    }

    public func applicationWillResignActive(_ application: UIApplication){


    }

//    @available(iOS, introduced: 2.0, deprecated: 9.0, message: "Please use application:openURL:options:")
//    optional public func application(_ application: UIApplication, handleOpen url: URL) -> Bool
//
//    @available(iOS, introduced: 4.2, deprecated: 9.0, message: "Please use application:openURL:options:")
//    optional public func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool



    public func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

        return true
    }


    public func applicationDidReceiveMemoryWarning(_ application: UIApplication) {


    }

    public func applicationWillTerminate(_ application: UIApplication){

    }

    public func applicationSignificantTimeChange(_ application: UIApplication) {

    }


    public func application(_ application: UIApplication, willChangeStatusBarOrientation newStatusBarOrientation: UIInterfaceOrientation, duration: TimeInterval){

    }

    public func application(_ application: UIApplication, didChangeStatusBarOrientation oldStatusBarOrientation: UIInterfaceOrientation){

    }


    public func application(_ application: UIApplication, willChangeStatusBarFrame newStatusBarFrame: CGRect) {

    }

    public func application(_ application: UIApplication, didChangeStatusBarFrame oldStatusBarFrame: CGRect){

    }


    public func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings){

    }


    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){


    }

    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error){


    }


//    @available(iOS, introduced: 3.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:] for user visible notifications and -[UIApplicationDelegate application:didReceiveRemoteNotification:fetchCompletionHandler:] for silent remote notifications")
//    optional public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any])
//
//
//    @available(iOS, introduced: 4.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate willPresentNotification:withCompletionHandler:] or -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
//    optional public func application(_ application: UIApplication, didReceive notification: UILocalNotification)


    // Called when your app has been activated by the user selecting an action from a local notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
//    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
//    optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Swift.Void)


//    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
//    optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void)


    // Called when your app has been activated by the user selecting an action from a remote notification.
    // A nil action identifier indicates the default action.
    // You should call the completion handler as soon as you've finished handling the action.
//    @available(iOS, introduced: 8.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
//    optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void)


//    @available(iOS, introduced: 9.0, deprecated: 10.0, message: "Use UserNotifications Framework's -[UNUserNotificationCenterDelegate didReceiveNotificationResponse:withCompletionHandler:]")
//    optional public func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Swift.Void)


    /*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.

     This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){

    }


    public func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Swift.Void){

    }


//    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Swift.Void){
//
//
//    }


    public func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Swift.Void){


    }


    public func application(_ application: UIApplication, handleWatchKitExtensionRequest userInfo: [AnyHashable : Any]?, reply: @escaping ([AnyHashable : Any]?) -> Swift.Void){

    }


    public func applicationShouldRequestHealthAuthorization(_ application: UIApplication){

    }


    public func applicationDidEnterBackground(_ application: UIApplication){

    }

    public func applicationWillEnterForeground(_ application: UIApplication){

    }


    public func applicationProtectedDataWillBecomeUnavailable(_ application: UIApplication){

    }

    public func applicationProtectedDataDidBecomeAvailable(_ application: UIApplication){

    }


    public var window: UIWindow?


    public func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.portrait
    }


    public func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplicationExtensionPointIdentifier) -> Bool{
        return true
    }


    public func application(_ application: UIApplication, viewControllerWithRestorationIdentifierPath identifierComponents: [Any], coder: NSCoder) -> UIViewController?{
        return nil
    }

    public func application(_ application: UIApplication, shouldSaveApplicationState coder: NSCoder) -> Bool{
        return true
    }

    public func application(_ application: UIApplication, shouldRestoreApplicationState coder: NSCoder) -> Bool{
        return true
    }

    public func application(_ application: UIApplication, willEncodeRestorableStateWith coder: NSCoder){

    }

    public func application(_ application: UIApplication, didDecodeRestorableStateWith coder: NSCoder){

    }


    public func application(_ application: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool{

        return true
    }


    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Swift.Void) -> Bool{

        return true
    }


    public func application(_ application: UIApplication, didFailToContinueUserActivityWithType userActivityType: String, error: Error){

    }


    public func application(_ application: UIApplication, didUpdate userActivity: NSUserActivity){

    }


//    public func application(_ application: UIApplication, userDidAcceptCloudKitShareWith cloudKitShareMetadata: CKShareMetadata){
//
//    }
}
