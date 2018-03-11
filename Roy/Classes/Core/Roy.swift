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

public protocol RoyValidatorProtocol {
    static func validate(params:[String:Any]?) -> (result:Bool,reason:String?)
}

public class RoyTaskMapping{
    var url  : RoyURL
    var task : RoyTaskClosure
    var validator : RoyValidatorProtocol.Type?
    
    init(url:RoyURL,task:@escaping RoyTaskClosure,validator:RoyValidatorProtocol.Type?) {
        self.url = url
        self.task = task
        self.validator = validator
    }
}





public class RoyR: NSObject {
    
    static public let global = RoyR()
    
    fileprivate var urlTaskMap : [String:RoyTaskMapping] = [:]
	
    open func addRouter(url:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool {
        guard let u = RoyURLAnalyzer.convert(url: url) else {
            return false
        }
        self.urlTaskMap[u.key] = RoyTaskMapping(url: u, task: task, validator: paramValidator)
        return true
    }
    
    open func route(url:URL , param : [String:Any]?) -> Any?{
        guard let key = RoyURLAnalyzer.getKey(url: url.absoluteString) else {
            return false
        }
        
        var newParam = url.params
        if let p = param {
            newParam.combine(p)
        }
        if let validator = self.urlTaskMap[key]?.validator {
            if !validator.validate(params: newParam).result {
                return false
            }
        }
        
        guard let t = self.urlTaskMap[key]?.task else {
            print("closure unmatched,url -> \(key)")
            return false
        }
        
        let returnValue = t(newParam)
        return returnValue
    }
    

    open func route(url:URL , param : [String:Any]?  , task:RoyReturnClosure?) -> Bool {
        let returnValue = self.route(url: url, param: param)
        if let t = task{
        	t(returnValue)
        }
        return true
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


extension String{
    func roy_appending(string:String?) -> String {
        if let s = string {
            return self.appending(s)
        }
        return self
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
    var key : String?{
        get{
            return scheme?.roy_appending(string: host).roy_appending(string: path)
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



