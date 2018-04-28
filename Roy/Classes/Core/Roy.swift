//
//  RoyR.swift
//  Pods
//
//  Created by 金秋成 on 2017/8/10.
//
//




import UIKit
import PromiseKit

/// 任务block
public typealias RoyTaskClosure<T> = ([String:Any]?)->Promise<T>

/// 验证器协议
public protocol RoyValidatorProtocol {
    static func validate(url:RoyURL, params:[String:Any]?) -> (result:Bool,reason:String?)
}


/// Roy生命周期协议，全部为可选
public protocol RoyDelegate{
    
    //route life cycle
    func willRoute(url:URL,param:[String:Any]?)
    func didRouted(url:URL,param:[String:Any]?,error:Error?)
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


class RoyService<T> : NSObject {
    var url:String
    var validator:RoyValidatorProtocol.Type?
    var task : RoyTaskClosure<T>
    
    init(url:String,validator:RoyValidatorProtocol.Type?,task:@escaping RoyTaskClosure<T>) {
        self.url = url
        self.validator = validator
        self.task = task
    }
}

class RoyRequest : NSObject {
    var url		:	URL
    var param 	:	[String:Any]?
    var queue 	: 	DispatchQueue
    
    init(url:URL,param:[String:Any]?,queue:DispatchQueue?) {
        self.url = url
        self.param = param
        if let q = queue {
            self.queue = q
        }
        else{
            self.queue = DispatchQueue.main
        }
    }
}




/// 任务类
public class RoyTaskMapping<T>{
    
    /// url
    var url  : RoyURL
    
    /// 任务
    var task : RoyTaskClosure<T>
    
    /// 参数验证器
    var validator : RoyValidatorProtocol.Type?
    
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - url: RoyURL类
    ///   - task: 任务
    ///   - validator: 验证器
    init(url:RoyURL,task:@escaping RoyTaskClosure<T>,validator:RoyValidatorProtocol.Type?) {
        self.url = url
        self.task = task
        self.validator = validator
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

    let queue = DispatchQueue(label: "com.roy.workingqueue")
    
    /// 任务存储
    var urlTaskMap : [String:Any] = [:]
    /// 用默认日志系统
    public override init() {
        super.init()
        commonInit()
    }
    
    /// 公共初始化
    func commonInit() {
        
    }
    
    
    /// 添加url
    ///
    /// - Parameters:
    ///   - url: url 格式为  "xxxx://xxxx/xxxx?x=<number/text?>"
    ///   - task: 任务
    ///   - paramValidator: 验证器 用来调用route方法时 验证传入的参数
    /// - Returns: 添加成功与否
    open func addRouter<T>(url:String ,paramValidator:RoyValidatorProtocol.Type? , task:@escaping RoyTaskClosure<T>){
        let s = RoyService<T>(url: url, validator: paramValidator, task: task)
        self.addRouter(server: s)
    }
    func addRouter<T>(server : RoyService<T>){
        let url = server.url
        let paramValidator = server.validator
        let task = server.task
        guard let u = RoyURLAnalyzer.convert(url: url) else {
            return
        }
        self.lock.lock()
        self.urlTaskMap[u.key] = RoyTaskMapping(url: u, task: task, validator: paramValidator)
        self.lock.unlock()
    }


    open func route<T>(url:URL , param : [String:Any]?,in queue:DispatchQueue?)-> Promise<T>{
        let request = RoyRequest(url: url, param: param, queue: queue)
        return self.route(request: request)
    }
    
    
    func route<T>(request:RoyRequest) -> Promise<T> {
        
        let url = request.url
        let param = request.param
        let queue = request.queue
        weak var weakSelf = self
        
        
        return Promise<T>{ seal in
            
            
            weakSelf?.willRoute(url: url, param: param)
            
            
            guard let key = RoyURLAnalyzer.getKey(url: url.absoluteString) else {
                let err = RoyError(type: .ConvertError, message: "convert error")
                seal.reject(err)
                weakSelf?.didRouted(url: url, param: param, error: err)
                return
            }
            var newParam = url.params
            if let p = param {
                newParam.combine(p)
            }
            
            guard let task = weakSelf?.urlTaskMap[key] as? RoyTaskMapping<T> else{
                let err = RoyError(type: .TaskNotFound, message: "there has no task")
                seal.reject(err)
                weakSelf?.didRouted(url: url, param: param, error: err)
                return
            }
            
            
            if let validator = task.validator {
                let r = validator.validate(url:task.url, params: newParam)
                if !r.result {
                    let err = RoyError(type: .ParamValidationError, message: r.reason)
                    seal.reject(err)
                    weakSelf?.didRouted(url: url, param: param, error: err)
                    return
                }
            }
            _ = task.task(newParam).done(on: queue, { (obj) in
                seal.fulfill(obj);
                weakSelf?.didRouted(url: url, param: param, error: nil)
            })
        }
    }

}



extension RoyR:RoyDelegate{
    public static func regist(delegate:RoyDelegate){
        if !delegates.contains(delegate as AnyObject){
            delegates.add(delegate as AnyObject)
        }
    }
    
    public static func unregist(delegate:RoyDelegate){
        if delegates.contains(delegate as AnyObject){
            delegates.remove(delegate as AnyObject)
        }
    }
    
    func doInLoop(f:(RoyDelegate)->Void){
        for i in delegates.allObjects {
            if let obj = i as? RoyDelegate{
                 f(obj)
            }
        }
    }

    //route life cycle
    public func willRoute(url:URL,param:[String:Any]?){
        doInLoop { $0.willRoute(url: url, param: param)}
    }
    
    public func didRouted(url: URL, param: [String : Any]?, error: Error?) {
        doInLoop { $0.didRouted(url: url, param: param, error: error) }
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
        if var s = string {
            if s.hasPrefix("/"){
                s.removeFirst()
            }
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
            return scheme?.roy_appending(string: "://").roy_appending(string: host).roy_appending(string: path)
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



