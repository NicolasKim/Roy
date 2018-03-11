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

protocol RoyLogProtocol{
    func addRegistLog(withURL url:String,message:String?,errorType:RoyLogErrorType)
    func addRouteLog(withURL url:String,url_rule:String?,message:String?,errorType:RoyLogErrorType)
}

enum RoyError : Error {
    case ConvertError
    case ParamValidationError
    case TaskNotFound
    case ErrorOther
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
    var logDelegate : RoyLogProtocol?
    fileprivate var urlTaskMap : [String:RoyTaskMapping] = [:]
	
    public override init() {
        super.init()
        self.registLog(delegate: RoyDefaultLogSystem(saveToDB: true))
    }
	
    init(logDelegate:RoyLogProtocol) {
    	super.init()
        self.registLog(delegate: logDelegate)
    }
    
    
    open func addRouter(url:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool {
        do {
            guard let u = RoyURLAnalyzer.convert(url: url) else {
                throw RoyError.ConvertError
            }
            self.logDelegate?.addRegistLog(withURL: url, message: "convert success and added", errorType: RoyLogErrorType.None)
            self.urlTaskMap[u.key] = RoyTaskMapping(url: u, task: task, validator: paramValidator)
        }
        catch RoyError.ConvertError{
            self.logDelegate?.addRegistLog(withURL: url, message: "convert error", errorType: RoyLogErrorType.ConvertError)
            return false
        }
        catch{
            self.logDelegate?.addRegistLog(withURL: url, message: "unknown", errorType: RoyLogErrorType.Unknown)
            return false
        }
        return true
    }
    
    open func route(url:URL , param : [String:Any]?) -> Any?{
        
        do {
            guard let key = RoyURLAnalyzer.getKey(url: url.absoluteString) else {
                throw RoyError.ConvertError
            }
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "convert success", errorType: RoyLogErrorType.None)
            var newParam = url.params
            if let p = param {
                newParam.combine(p)
            }
            if let validator = self.urlTaskMap[key]?.validator {
                if !validator.validate(params: newParam).result {
                    throw RoyError.ParamValidationError
                }
                self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "param validate success", errorType: RoyLogErrorType.None)
            }
            
            guard let t = self.urlTaskMap[key]?.task else {
                throw RoyError.TaskNotFound
            }
            
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "find task success", errorType: RoyLogErrorType.None)
            let returnValue = t(newParam)
            
            return returnValue
            
        } catch RoyError.ConvertError {
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "convert error", errorType: RoyLogErrorType.ConvertError)
            return nil
        } catch RoyError.ParamValidationError{
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "param validate error", errorType: RoyLogErrorType.ParamValidateError)
            return nil
        } catch RoyError.TaskNotFound{
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "there has no task", errorType: RoyLogErrorType.TaskNotFound)
            return nil
        } catch{
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "unknown", errorType: RoyLogErrorType.Unknown)
            return nil
        }
    }
    

    open func route(url:URL , param : [String:Any]?  , task:RoyReturnClosure?) -> Bool {
        let returnValue = self.route(url: url, param: param)
        if let t = task{
        	t(returnValue)
        }
        return true
    }
}



extension RoyR{
    func registLog(delegate:RoyLogProtocol) {
        self.logDelegate = delegate
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


