//
//  RoyR.swift
//  Pods
//
//  Created by 金秋成 on 2017/8/10.
//
//

import UIKit

public typealias RoyTaskClosure = ([String:Any]?)->Any

public typealias RoyReturnClosure = (Any?)->Void


public class RoyR: NSObject {
   
    fileprivate var urlTaskMap : [String:Any] = [:]

    open func addRouter(url:URL , task:@escaping RoyTaskClosure) -> Bool {

        guard let s = url.scheme ,let h = url.host  else{
#if DEBUG
            print("url error")
#endif
            return false
        }

        let url = "\(s)://\(h)\(url.path)"

        self.urlTaskMap[url] = task
        return true
    }

    open func route(url:URL , param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool {

        guard let s = url.scheme ,let h = url.host  else{
#if DEBUG
            print("url error")
#endif
            return false
        }

        let urlString = "\(s)://\(h)\(url.path)"

        var newParam = url.params
        if let p = param {
            newParam.combine(p)
        }
        
        
        guard let t = self.urlTaskMap[urlString] as? RoyTaskClosure else {
            
            print("closure unmatched,url -> \(urlString)")

            return false
        }

        let returnValue = t(newParam)
        
        task(returnValue)

        return true

    }

    
    open func route(url:URL , param : [String:Any]? ) -> Any?{
        guard let s = url.scheme ,let h = url.host  else{
            #if DEBUG
                print("url error")
            #endif
            return nil
        }
        
        let urlString = "\(s)://\(h)\(url.path)"
        
        
        var newParam = url.params
        if let p = param {
            newParam.combine(p)
        }
        
        
        
        
        
        guard let t = self.urlTaskMap[urlString] as? RoyTaskClosure else {
            
            print("closure unmatched,url -> \(urlString)")
            
            return nil
        }
        
        let returnValue = t(newParam)

        return returnValue
    }
    
    

}


public class RoyGlobal: RoyR {
    static public let instance = RoyGlobal()
}



public protocol RoyProtocol : NSObjectProtocol {
    init?(param : [String:Any]?)
}


/*
 *  UIKit extension
 */

public extension RoyR{
    public func addRouter(url:URL , viewController : RoyProtocol.Type) -> Bool{
        let c : RoyTaskClosure = { (p : [String:Any]?) -> RoyProtocol? in
            
            if let vc = viewController.init(param: p) {
                return vc
            }
            return nil
        }
        return self.addRouter(url: url, task: c)
    }
    
    public func viewController(url:URL,param:[String:Any]?) -> RoyProtocol?{
        return self.route(url: url, param: param) as? RoyProtocol
    }
    
}

public extension UIViewController{
    
    
    public func present(url : URL, param : [String:Any]?, animated: Bool, completion: (() -> Void)?){
        if let vc = RoyGlobal.instance.viewController(url: url, param: param) as? UIViewController{
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
        if let vc = RoyGlobal.instance.viewController(url: url,param:param) as? UIViewController{
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
            if let vc = RoyGlobal.instance.viewController(url: url,param:nil) as? UIViewController{
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
            if let vc = RoyGlobal.instance.viewController(url: url,param:nil) as? UIViewController{
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






private var key: Void?

public extension NSObject{
    var roy: RoyR {
        get {
            if let r = objc_getAssociatedObject(self, &key) as? RoyR {
                return r
            }
            else{
                let r = RoyR()
                objc_setAssociatedObject(self, &key, r, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return r
            }
        }
    }
}



public extension URL{
    var params : [String : Any]{
        get{
            var ps : [String:Any] = [:]
            if let keyValues = self.query?.components(separatedBy: "&") {
                for keyValue in keyValues {
                    let kv = keyValue.components(separatedBy: "=")
                    ps[kv.first!] = kv.last!
                }
            }
            return ps;
        }
    }
}


public extension Dictionary{
    mutating func combine(_ dict : Dictionary) {
        for e in dict{
            self.updateValue(e.value, forKey: e.key)
        }
    }
}



