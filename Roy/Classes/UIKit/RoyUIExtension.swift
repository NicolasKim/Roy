//
//  RoyUIExtension.swift
//  Pods-Roy_Example
//
//  Created by dreamtracer on 2018/3/11.
//

import Foundation

enum RoyUIExtensionError :Error {
    case Convert
    case Unknown
    
}

public protocol RoyProtocol {
    init?(param : [String:Any]?)
}


/*
 *  UIKit extension
 */

public extension RoyR{
    public func addRouter(url:String , viewController : RoyProtocol.Type ,paramValidator: RoyValidatorProtocol.Type?) -> Bool{
        let c : RoyTaskClosure = { (p : [String:Any]?) -> RoyProtocol? in
            if let vc = viewController.init(param: p) {
                return vc
            }
            return nil
        }
        return self.addRouter(url: url, task: c, paramValidator: paramValidator)
    }
    
    public func viewController(url:URL,param:[String:Any]?) -> UIViewController?{
        do{
            guard let vc = self.route(url: url, param: param) else {
                throw RoyUIExtensionError.Convert
            }
            return vc as? UIViewController
        }
        catch RoyUIExtensionError.Convert{
            return nil
        }
        catch{
            return nil
        }
    }
    
}

public extension UIViewController{
    public func present(url : URL, param : [String:Any]?, animated: Bool, completion: (() -> Void)?){
        if let vc = RoyR.global.viewController(url: url, param: param){
            self.present(vc, animated: animated, completion: completion)
        }
        else{
            #if DEBUG
                print("URL:\(url) did not registed,or the object mapped with \(url) is not a viewcontroller")
            #endif
        }
    }
}


public extension UINavigationController{
    public func pushViewController(url: URL , param : [String : Any] , animated: Bool){
        if let vc = RoyR.global.viewController(url: url,param:param){
            self.pushViewController(vc, animated: animated)
        }
        else{
            #if DEBUG
                print("URL:\(url) did not registed,or the object mapped with \(url) is not a viewcontroller")
            #endif
        }
    }
    
    public func setViewControllers(urls : [URL], animated: Bool){
        var vcs : [UIViewController] = []
        for url in urls {
            if let vc = RoyR.global.viewController(url: url,param:nil) as? UIViewController{
                vcs.append(vc)
            }
            else{
                #if DEBUG
                    print("URL:\(url) did not registed,or the object mapped with \(url) is not a viewcontroller")
                #endif
            }
        }
        self.setViewControllers(vcs, animated: animated)
    }
}


public extension UITabBarController{
    
    func setViewControllers(urls : [URL], animated: Bool){
        var vcs : [UIViewController] = []
        for url in urls {
            if let vc = RoyR.global.viewController(url: url,param:nil){
                vcs.append(vc)
            }
            else{
                #if DEBUG
                    print("URL:\(url) did not registed,or the object mapped with \(url) is not a viewcontroller")
                #endif
            }
        }
        self.setViewControllers(vcs, animated: animated)
    }
    
}
