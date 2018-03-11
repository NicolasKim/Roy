import UIKitpublic protocol RoyModuleProtocol : UIApplicationDelegate {    var scheme              : String {get  set}    var moduleHost          : String {get  set}        init(appScheme : String,host : String)        func route(path:String ,param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool        func viewController(path:String,param:[String:Any]?) -> UIViewController?}open class RoyModule : NSObject, RoyModuleProtocol {    public var scheme      : String    public var moduleHost        : String        public required init(appScheme: String, host: String) {        scheme            = appScheme        moduleHost        = host        super.init()    }        open func addRouter(path:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool {        let urlString = "\(self.scheme)://\(moduleHost)/\(path)"
    	return RoyR.global.addRouter(url: urlString, task: task, paramValidator: paramValidator)    }    open func route(path:String ,param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool {        let urlString = "\(self.scheme)://\(moduleHost)/\(path)"        let url = URL(string: urlString)        return RoyR.global.route(url: url!, param: param, task: task)    }        open func addRouter(path:String , viewController : RoyProtocol.Type,paramValidator:RoyValidatorProtocol.Type?) -> Bool{        let urlString = "\(self.scheme)://\(moduleHost)/\(path)"
            return RoyR.global.addRouter(url: urlString, viewController: viewController, paramValidator: paramValidator)    }        open func viewController(path:String,param:[String:Any]?) -> UIViewController?{        let urlString = "\(self.scheme)://\(moduleHost)/\(path)"        let url = URL(string: urlString)        return RoyR.global.viewController(url: url!, param: param)    }}