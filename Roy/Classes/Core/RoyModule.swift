import Foundationpublic protocol RoyModuleProtocol:UIApplicationDelegate{    var scheme              : String {get  set}    var moduleHost          : String {get  set}        init(appScheme : String,host : String)    
    func route(path:String ,param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool
    
    func addRouter(path:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool}

public extension RoyModuleProtocol{
    public func addRouter(path:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool {
    	let urlString = "\(self.scheme)://\(moduleHost)/\(path)"
    	return RoyR.global.addRouter(url: urlString, paramValidator: paramValidator, task: task)
    }
    
    public func route(path:String ,param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool {
    	let urlString = "\(self.scheme)://\(moduleHost)/\(path)"
    	let url = URL(string: urlString)
    	return RoyR.global.route(url: url!, param: param, task: task)
    }
}
open class RoyModule : NSObject, RoyModuleProtocol {    public var scheme      : String    public var moduleHost        : String        public required init(appScheme: String, host: String) {        scheme            = appScheme        moduleHost        = host        super.init()    }}