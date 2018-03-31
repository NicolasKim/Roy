import Foundation/// Global Roy settingpublic class RoyModuleConfig {    static public let sharedInstance = RoyModuleConfig()    private var s = "roy"    /// scheme    public var scheme: String {        get {            return s        }        set {            s = newValue        }    }}public enum RoyLoadModuleMode : String {    //This mode Module will call '-init(host:)' when you use the url belong to this module ,    case Lazily="eRoyLoadModuleModeLazily"    //This mode Module will call '-init(host:)' immediately, when you invoke RoyAppDelegate.addModuleClass,    case Immediately="eRoyLoadModuleModeImmediately"}public protocol RoyModuleProtocol: UIApplicationDelegate {        /// The host host    var moduleHost: String { get }    /// The host mapping to Module    ///    /// - Returns: host    static func host()->String	
    init(host: String)
    /// 注册任务    ///    /// - Parameters:    ///   - path: 任务对应的path，也就是任务名称    ///   - task: 任务    ///   - paramValidator: 参数验证器    /// - Returns: 注册任务结果    func addRouter(path: String, task: @escaping RoyTaskClosure, paramValidator: RoyValidatorProtocol.Type?) -> Bool    /// 加载方式    ///    /// - Returns: 加载方式    static func loadModuleMode()->RoyLoadModuleMode}public extension RoyModuleProtocol {    /// 注册任务    ///    /// - Parameters:    ///   - path: 任务对应的path，也就是任务名称    ///   - task: 任务    ///   - paramValidator: 参数验证器    /// - Returns: 注册任务结果    public func addRouter(path: String, task: @escaping RoyTaskClosure, paramValidator: RoyValidatorProtocol.Type?) -> Bool {        let urlString = "\(RoyModuleConfig.sharedInstance.scheme)://\(moduleHost)/\(path)"        return RoyR.global.addRouter(url: urlString, paramValidator: paramValidator, task: task)    }
    public static func loadModuleMode() -> RoyLoadModuleMode {
    	return .Lazily
    }}//open class RoyModule: NSObject, RoyModuleProtocol {
//    public let moduleHost: String
//
//    /// 默认初始化方法
//    ///
//    /// - Parameter host: 模块儿对应的host
//    public required init(host: String) {
//        moduleHost = host
//        super.init()
//    }
//
//    public class func loadModuleMode() -> RoyLoadModuleMode {
//        return .Lazily
//    }
//
//    public class func host() -> String {
//        return "roydefaulthost"
//    }
//}
