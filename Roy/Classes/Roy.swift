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







