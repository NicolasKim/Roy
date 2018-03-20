//
//  RoyR.swift
//  Pods
//
//  Created by 金秋成 on 2017/8/10.
//
//




import UIKit


/// 任务block
public typealias RoyTaskClosure = ([String:Any]?)->Any?

/// 任务返回的block
public typealias RoyReturnClosure = (Any?)->Void


/// 验证器协议
public protocol RoyValidatorProtocol {
    static func validate(url:RoyURL, params:[String:Any]?) -> (result:Bool,reason:String?)
}


/// 日志系统协议
protocol RoyLogProtocol{
    func addRegistLog(withURL url:String,message:String?,errorType:RoyLogErrorType)
    func addRouteLog(withURL url:String,url_rule:String?,message:String?,errorType:RoyLogErrorType)
}

/// Roy生命周期协议，全部为可选
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


/// Roy错误结构体
struct RoyError : Error {
    enum EType : Error {
        case None
        case ConvertError
        case ParamValidationError
        case TaskNotFound
        case RoyNotFound
        case Other
    }
    
    var type 	: EType = .None
    var message	: String?
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - type: EType
    ///   - message: 错误信息（暂不支持国际化）
    init(type:EType,message:String?) {
        self.type = type
        self.message = message
    }
}





/// 任务类
public class RoyTaskMapping{
    
    /// url
    var url  : RoyURL
    
    /// 任务
    var task : RoyTaskClosure
    
    /// 参数验证器
    var validator : RoyValidatorProtocol.Type?
    
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - url: RoyURL类
    ///   - task: 任务
    ///   - validator: 验证器
    init(url:RoyURL,task:@escaping RoyTaskClosure,validator:RoyValidatorProtocol.Type?) {
        self.url = url
        self.task = task
        self.validator = validator
    }
}

public class RoyOperation: Operation {
    
    var roy_finished = false
    var roy_executing = false
   	weak var r:RoyR?
    var  url:URL
    var  params:[String:Any]?
    var  returnTask:RoyReturnClosure?
	
    init(url:URL,params:[String:Any]?,returnTask:RoyReturnClosure?) {
        self.url = url
        self.params = params
        self.returnTask = returnTask
        super.init()
    }
    
    public func setRoy(_ roy:RoyR) {
        r = roy
    }
	
    override public func start() {
        if self.isCancelled{
            self.willChangeValue(forKey: "isFinished")
            self.roy_finished = true
            self.didChangeValue(forKey: "isFinished")
            return;
        }
        else{
            self.willChangeValue(forKey: "isExecuting")
            self.roy_executing = true
            self.main()
            self.didChangeValue(forKey: "isExecuting")
        }
    }
    
    
    override public func main() {
        do {
            
            guard let roy = r else {
                throw RoyError(type: .RoyNotFound, message: "set Roy please!")
            }
            
            
            roy.willAnalyze(url: self.url, param: params)
            guard let key = RoyURLAnalyzer.getKey(url: url.absoluteString) else {
                throw RoyError(type: .ConvertError, message: "convert error")
            }
            roy.didAnalyzed(url: self.url, param: self.params, error: nil)
            roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "convert success", errorType: RoyLogErrorType.None)
            var newParam = url.params
            if let p = self.params {
                newParam.combine(p)
            }
            roy.willValidate(url: self.url, param: self.params)
            if let validator = roy.urlTaskMap[key]?.validator {
                let r = validator.validate(url:roy.urlTaskMap[key]!.url, params: newParam)
                if !r.result {
                    throw RoyError(type: .ParamValidationError, message: r.reason)
                }
                roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "param validate success", errorType: RoyLogErrorType.None)
            }
            roy.didValidated(url: self.url, param: self.params, error: nil)
            
            roy.willFindTask(url: url, param: params)
            guard let t = roy.urlTaskMap[key]?.task else {
                throw RoyError(type: .TaskNotFound, message: "there has no task")
            }
            roy.didFoundTask(url: url, param: params, error: nil)
            
            roy.willRoute(url: url, param: params)
            roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "find task success", errorType: RoyLogErrorType.None)
            let returnValue = t(newParam)
            if let rt = self.returnTask {
                rt(returnValue)
            }
            roy.didRouted(url: url, param: params, error: nil)
            
//            [self willChangeValueForKey:@"isFinished"];
//
//            [self willChangeValueForKey:@"isExecuting"];
//
//            finished = YES;
//
//            executing = NO;
//
//            [self didChangeValueForKey:@"isFinished"];
//
//            [self didChangeValueForKey:@"isExecuting"];
            
            self.willChangeValue(forKey: "isFinished")
            self.willChangeValue(forKey: "isExecuting")
            roy_finished = true
            roy_executing = false
            self.didChangeValue(forKey: "isFinished")
            self.didChangeValue(forKey: "isExecuting")
        } catch let error as RoyError {
            switch error.type {
            case .ConvertError:
                roy.didAnalyzed(url: url, param: params, error: error)
                roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "convert error", errorType: RoyLogErrorType.ConvertError)
                RoyPrint("convert error,url=>\(url.absoluteString)")
            case .ParamValidationError:
                roy.didValidated(url: url, param: params, error: error)
                roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: error.message, errorType: RoyLogErrorType.ParamValidateError)
                if let m = error.message {
                    RoyPrint("param validation error,reason:\(m),url=>\(url.absoluteString)")
                }
                else{
                    RoyPrint("param validation error,url=>\(url.absoluteString)")
                }
            case .TaskNotFound:
                roy.didFoundTask(url: url, param: params, error: error)
                roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "there has no task", errorType: RoyLogErrorType.TaskNotFound)
                RoyPrint("there has no task,url=>\(url.absoluteString)")
            default:
                roy.didRouted(url: url, param: params, error: error)
                roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "unknown", errorType: RoyLogErrorType.Unknown)
                RoyPrint("unknown,url=>\(url.absoluteString)")
            }
            if let rt = self.returnTask {
                rt(nil)
            }
        } catch{
            roy.logDelegate?.addRouteLog(withURL: url.absoluteString, url_rule: nil, message: "unknown", errorType: RoyLogErrorType.Unknown)
            RoyPrint("unknown,url=>\(url.absoluteString)")
            if let rt = self.returnTask {
                rt(nil)
            }
        }
    }
    
    
    
    override public var isFinished: Bool{
        return roy_finished
    }
    override public var isExecuting: Bool{
        return roy_executing
    }
    
    
    
}


/// Roy生命周期代理注册
private var delegates  = NSHashTable<AnyObject>(options: NSPointerFunctions.Options.weakMemory)


/// Roy核心类
public class RoyR: NSObject {
    
    /// 单利（全局使用）
    static public let global = RoyR()
    
    /// 保证多线程访问时的线程安全
    let lock = NSLock()
    
    /// 日志系统代理
    var logDelegate : RoyLogProtocol?
    
    /// 生命周期代理方法调用时的队列，考虑到如果代理比较多时影响性能
    let lifeCycleQueue:OperationQueue = OperationQueue()
    
    /// 任务存储
    var urlTaskMap : [String:RoyTaskMapping] = [:]
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
    
    /// 公共初始化
    func commonInit() {
        //修改为串行队列
        lifeCycleQueue.maxConcurrentOperationCount = 1
    }
    
    /// 添加任务
    ///
    /// - Parameters:
    ///   - url:RoyURL对象
    ///   - task: 任务
    ///   - paramValidator: 验证器
    ///   - queue: 添加时使用的队列
    /// - Returns: 线程
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
        var result : Any?
        _=self.route(url: url, param: param, queue: OperationQueue.main) { (r) in
            result = r
        }
        return result
    }
    

    open func route(url:URL , param : [String:Any]?  , task:RoyReturnClosure?) -> Bool {
        _ = self.route(url: url, param: param, queue: OperationQueue.main, task: task)
        return true
    }
    
    open func route(url:URL , param : [String:Any]?,queue:OperationQueue ,task:RoyReturnClosure?) -> RoyOperation {
        let op = RoyOperation(url: url, params: param, returnTask: task)
        op.setRoy(self)
        queue.addOperation(op)
        return op
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



