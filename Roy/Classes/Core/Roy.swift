//
//  RoyR.swift
//  Pods
//
//  Created by 金秋成 on 2017/8/10.
//
//




import UIKit


public typealias RoyTaskClosure = ([String:Any]?)->Any?

public typealias RoyReturnClosure = (Any?)->Void

public protocol RoyValidatorProtocol {
    static func validate(url:RoyURL, params:[String:Any]?) -> (result:Bool,reason:String?)
}

protocol RoyLogProtocol{
    func addRegistLog(withURL url:String,message:String?,errorType:RoyLogErrorType)
    func addRouteLog(withURL url:String,url_rule:String?,message:String?,errorType:RoyLogErrorType)
}

@objc public protocol RoyDelegate:NSObjectProtocol{
    //add life cycle
    @objc optional func willConvert(url:String)
    @objc optional func didConverted(url:String,error:Error?)
    @objc optional func willAdd(url:String)
    @objc optional func didAdd(url:String,error:Error?)
    
    //route life cycle
    @objc optional func willAnalyze(url:URL,param:[String:Any]?)
    @objc optional func didAnalyzed(url:URL,param:[String:Any]?,error:Error?)
    @objc optional func willValidate(url:URL,param:[String:Any]?)
    @objc optional func didValidated(url:URL,param:[String:Any]?,error:Error?)
    @objc optional func willFindTask(url:URL,param:[String:Any]?)
    @objc optional func didFoundTask(url:URL,param:[String:Any]?,error:Error?)
    @objc optional func willRoute(url:URL,param:[String:Any]?)
    @objc optional func didRouted(url:URL,param:[String:Any]?,error:Error?)
}

struct RoyError : Error {
    enum EType : Error {
        case None
        case ConvertError
        case ParamValidationError
        case TaskNotFound
        case Other
    }
    
    var type 	: EType = .None
    var message	: String?
    
    init(type:EType,message:String?) {
        self.type = type
        self.message = message
    }
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




private var delegates  = NSHashTable<AnyObject>(options: NSPointerFunctions.Options.weakMemory)

public class RoyR: NSObject {
    
    static public let global = RoyR()
    let lock = NSLock()
    var logDelegate : RoyLogProtocol?
    let lifeCycleQueue:OperationQueue = OperationQueue()
    fileprivate var urlTaskMap : [String:RoyTaskMapping] = [:]
    /// 用默认日志系统
    public override init() {
        super.init()
        commonInit()
        self.registLog(delegate: RoyDefaultLogSystem(saveToDB: true))
    }
	
    /// 自定义日志系统
    ///
    /// - Parameter logDelegate: 日志系统
    init(logDelegate:RoyLogProtocol) {
    	super.init()
        commonInit()
        self.registLog(delegate: logDelegate)
    }
    
    func commonInit() {
        lifeCycleQueue.maxConcurrentOperationCount = 1
    }
    
    open func addRouter(url:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?,inQueue queue:OperationQueue) -> Operation{
        let op = BlockOperation {
            _ = self.addRouter(url: url , paramValidator: paramValidator, task: task)
        }
        queue.addOperation(op)
        return op
    }
    
    
    /// 添加url
    ///
    /// - Parameters:
    ///   - url: url 格式为  "xxxx://xxxx/xxxx?x=<number/text?>"
    ///   - task: 任务
    ///   - paramValidator: 验证器 用来调用route方法时 验证传入的参数
    /// - Returns: 添加成功与否
    open func addRouter(url:String ,paramValidator:RoyValidatorProtocol.Type? , task:@escaping RoyTaskClosure) -> Bool {
        do {
            self.willConvert(url: url)
            guard let u = RoyURLAnalyzer.convert(url: url) else {
                throw RoyError(type: .ConvertError, message: "convert error")
            }
            self.didConverted(url: url, error: nil)
            self.logDelegate?.addRegistLog(withURL: url, message: "convert success and added", errorType: RoyLogErrorType.None)
            self.lock.lock()
            self.willAdd(url: url)
            self.urlTaskMap[u.key] = RoyTaskMapping(url: u, task: task, validator: paramValidator)
            self.didAdd(url: url, error: nil)
            self.lock.unlock()
        }
        catch let error as RoyError{
            switch error.type {
            case .ConvertError:
                self.didConverted(url: url, error: error)
                self.logDelegate?.addRegistLog(withURL: url, message: "convert error", errorType: RoyLogErrorType.ConvertError)
                RoyPrint("convert error,url=>\(url)")
            default:
                self.didAdd(url: url, error: error)
                self.logDelegate?.addRegistLog(withURL: url, message: "unknown", errorType: RoyLogErrorType.Unknown)
                RoyPrint("unknown error,url=>\(url)")
            }
            return false
        }
        catch{
            self.logDelegate?.addRegistLog(withURL: url, message: "unknown", errorType: RoyLogErrorType.Unknown)
            RoyPrint("unknown error,url=>\(url)")
            return false
        }
        return true
    }
    
    
    /// url调用
    ///
    /// - Parameters:
    ///   - url: url "xxxx://xxxx/xxxx?x=123" 其中x=123会合并到param中
    ///   - param: 参数，可以是任意类型
    /// - Returns: 任务执行过后的返回值
    open func route(url:URL , param : [String:Any]?) -> Any?{
        
        do {
            self.willAnalyze(url: url, param: param)
            guard let key = RoyURLAnalyzer.getKey(url: url.absoluteString) else {
                throw RoyError(type: .ConvertError, message: "convert error")
            }
            self.didAnalyzed(url: url, param: param, error: nil)
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "convert success", errorType: RoyLogErrorType.None)
            var newParam = url.params
            if let p = param {
                newParam.combine(p)
            }
            self.willValidate(url: url, param: param)
            if let validator = self.urlTaskMap[key]?.validator {
                let r = validator.validate(url:self.urlTaskMap[key]!.url, params: newParam)
                if !r.result {
                    throw RoyError(type: .ParamValidationError, message: r.reason)
                }
                self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "param validate success", errorType: RoyLogErrorType.None)
            }
            self.didValidated(url: url, param: param, error: nil)
            
            self.willFindTask(url: url, param: param)
            guard let t = self.urlTaskMap[key]?.task else {
                throw RoyError(type: .TaskNotFound, message: "there has no task")
            }
            self.didFoundTask(url: url, param: param, error: nil)
            
            self.willRoute(url: url, param: param)
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "find task success", errorType: RoyLogErrorType.None)
            let returnValue = t(newParam)
            self.didRouted(url: url, param: param, error: nil)
            return returnValue
            
        } catch let error as RoyError {
            switch error.type {
            case .ConvertError:
                self.didAnalyzed(url: url, param: param, error: error)
                self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "convert error", errorType: RoyLogErrorType.ConvertError)
                RoyPrint("convert error,url=>\(url.absoluteString)")
            case .ParamValidationError:
                self.didValidated(url: url, param: param, error: error)
                self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: error.message, errorType: RoyLogErrorType.ParamValidateError)
                if let m = error.message {
                    RoyPrint("param validation error,reason:\(m),url=>\(url.absoluteString)")
                }
                else{
                    RoyPrint("param validation error,url=>\(url.absoluteString)")
                }
            case .TaskNotFound:
                self.didFoundTask(url: url, param: param, error: error)
                self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "there has no task", errorType: RoyLogErrorType.TaskNotFound)
                RoyPrint("there has no task,url=>\(url.absoluteString)")
            default:
                self.didRouted(url: url, param: param, error: error)
                self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "unknown", errorType: RoyLogErrorType.Unknown)
                RoyPrint("unknown,url=>\(url.absoluteString)")
            }
            return nil
        } catch{
            self.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "unknown", errorType: RoyLogErrorType.Unknown)
            RoyPrint("unknown,url=>\(url.absoluteString)")
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


extension RoyR:RoyDelegate{
    public static func regist(delegate:RoyDelegate){
        if !delegates.contains(delegate){
        	delegates.add(delegate)
        }
    }
    
    public static func unregist(delegate:RoyDelegate){
        if delegates.contains(delegate){
        	delegates.remove(delegate)
        }
    }
    
    func doInLoop(f:@escaping (_ o:RoyDelegate)->Void) {
        self.lifeCycleQueue.addOperation {
            for i in delegates.allObjects {
                if let obj = i as? RoyDelegate{
                    f(obj)
                }
            }
        }
    }
    
    
    //add life cycle
    public func willConvert(url:String){
        doInLoop { (obj) in
            obj.willConvert?(url: url)
        }
    }
    public func didConverted(url:String,error:Error?){
        doInLoop { (obj) in
            obj.didConverted?(url: url, error: error)
        }
    }
    public func willAdd(url:String){
        doInLoop { (obj) in
            obj.willAdd?(url: url)
        }
    }
    public func didAdd(url:String,error:Error?){
        doInLoop { (obj) in
            obj.didAdd?(url: url,error: error)
        }
    }
    //route life cycle
    public func willAnalyze(url:URL,param:[String:Any]?){
        doInLoop { (obj) in
            obj.willAnalyze?(url: url, param: param)
        }
    }
    public func didAnalyzed(url:URL,param:[String:Any]?,error:Error?){
        doInLoop { (obj) in
            obj.didAnalyzed?(url: url, param: param, error: error)
        }
    }
    public func willValidate(url:URL,param:[String:Any]?){
        doInLoop { (obj) in
            obj.willValidate?(url: url, param: param)
        }
    }
    public func didValidated(url:URL,param:[String:Any]?,error:Error?){
        doInLoop { (obj) in
            obj.didValidated?(url: url, param: param, error: error)
        }
    }
    public func willFindTask(url:URL,param:[String:Any]?){
        doInLoop { (obj) in
            obj.willFindTask?(url: url, param: param)
        }
    }
    public func didFoundTask(url:URL,param:[String:Any]?,error:Error?){
        doInLoop { (obj) in
            obj.didFoundTask?(url: url, param: param, error: error)
        }
    }
    public func willRoute(url:URL,param:[String:Any]?){
        doInLoop { (obj) in
            obj.willRoute?(url: url, param: param)
        }
    }
    public func didRouted(url:URL,param:[String:Any]?,error:Error?){
        doInLoop { (obj) in
            obj.didRouted?(url: url, param: param, error: error)
        }
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



