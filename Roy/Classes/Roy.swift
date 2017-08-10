//
//  RoyR.swift
//  Pods
//
//  Created by 金秋成 on 2017/8/10.
//
//

import UIKit

public typealias RoyTaskClosure<P,R> = (P)->(R)

public typealias RoyReturnClosure<P> = (P)->(Void)


public class RoyR: NSObject {
   
    fileprivate var schemeTaskMap : [String:Any] = [:]

    open func addRouter<P,R>(urlComponents:URLComponents , task:@escaping RoyTaskClosure<P,R>) -> Bool {

        guard let s = urlComponents.scheme ,let h = urlComponents.host  else{
#if DEBUG
            print("url error")
#endif
            return false
        }

        let url = s.appending(h).appending(urlComponents.path)

        self.schemeTaskMap[url] = task
        return true
    }

    open func route<R>(urlComponents:URLComponents  , task:@escaping RoyReturnClosure<R>) -> Bool {

        guard let s = urlComponents.scheme ,let h = urlComponents.host  else{
#if DEBUG
            print("url error")
#endif
            return false
        }

        let url = s.appending(h).appending(urlComponents.path)
        var params : [String:String] = [:]
        if  let items = urlComponents.queryItems  {
            for item in items {
                params[item.name] = item.value
            }
        }

        return self.route(scheme: url, param: params, task: task)
    }




    open func addRouter<P,R>(scheme:String , task:@escaping RoyTaskClosure<P,R>) -> Bool {
        //检查
        self.schemeTaskMap[scheme] = task
        return true
    }
    
    open func route<P,R>(scheme:String , param : P , task:@escaping RoyReturnClosure<R>) -> Bool {
        
        let t : RoyTaskClosure = self.schemeTaskMap[scheme] as! RoyTaskClosure<P,R>
        
        let returnValue = t(param)
        
        task(returnValue)

        return true
    }


    open func route<R>(url:String , task:@escaping RoyReturnClosure<R>) -> Bool {

        let urlComponents = URLComponents(string: url)

        guard  let comp = urlComponents else {
#if DEBUG
            print("scheme error")
#endif
            return false
        }

        return self.route(urlComponents: comp, task: task)
    }
}


public class RoyGlobal: RoyR {
    static public let instance = RoyGlobal()
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







