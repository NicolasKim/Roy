import Foundation/// 全局配置
public class RoyModuleConfig {    static public let sharedInstance = RoyModuleConfig()    private var s = "roy"    /// scheme配置
    public var scheme: String {        get {            return s        }        set {            s = newValue        }    }}public protocol RoyModuleProtocol: UIApplicationDelegate {
        /// 模块儿对应的host
    var moduleHost: String { get set }	    /// 初始化，必须实现
    ///
    /// - Parameter host: 模块儿对应的host
    init(host: String)	    /// 执行任务
    ///
    /// - Parameters:
    ///   - path: 任务对应的path，也就是任务名称
    ///   - param:参数
    ///   - task: 任务
    /// - Returns: 任务执行结果
    func route(path: String, param: [String: Any]?, task: @escaping RoyReturnClosure) -> Bool    /// 注册任务
    ///
    /// - Parameters:
    ///   - path: 任务对应的path，也就是任务名称
    ///   - task: 任务
    ///   - paramValidator: 参数验证器
    /// - Returns: 注册任务结果
    func addRouter(path: String, task: @escaping RoyTaskClosure, paramValidator: RoyValidatorProtocol.Type?) -> Bool}public extension RoyModuleProtocol {
    /// 注册任务
    ///
    /// - Parameters:
    ///   - path: 任务对应的path，也就是任务名称
    ///   - task: 任务
    ///   - paramValidator: 参数验证器
    /// - Returns: 注册任务结果    public func addRouter(path: String, task: @escaping RoyTaskClosure, paramValidator: RoyValidatorProtocol.Type?) -> Bool {        let urlString = "\(RoyModuleConfig.sharedInstance.scheme)://\(moduleHost)/\(path)"        return RoyR.global.addRouter(url: urlString, paramValidator: paramValidator, task: task)    }    /// 执行任务
    ///
    /// - Parameters:
    ///   - path: 任务对应的path，也就是任务名称
    ///   - param:参数
    ///   - task: 任务
    /// - Returns: 任务执行结果    public func route(path: String, param: [String: Any]?, task: @escaping RoyReturnClosure) -> Bool {        let urlString = "\(RoyModuleConfig.sharedInstance.scheme)://\(moduleHost)/\(path)"        let url = URL(string: urlString)        return RoyR.global.route(url: url!, param: param, task: task)    }}open class RoyModule: NSObject, RoyModuleProtocol {    public var moduleHost: String	    /// 默认初始化方法
    ///
    /// - Parameter host: 模块儿对应的host
    public required init(host: String) {        moduleHost = host        super.init()    }}