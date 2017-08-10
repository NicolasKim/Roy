//// Created by 金秋成 on 2017/8/10.//import UIKitpublic protocol RoyModuleProtocol : UIApplicationDelegate {    var scheme      : String {get  set}    var host        : String {get  set}    var identifier  : String {get  set}}public class RoyModule : NSObject, RoyModuleProtocol {    public var scheme      : String    public var host        : String    public var identifier  : String    init(appScheme : String){        scheme = appScheme        host        = ""        identifier  = ""        super.init()    }    open func addRouter<P,R>(path:String , task:@escaping RoyTaskClosure<P,R>) -> Bool {        let urlComponents = URLComponents(string: self.scheme.appending(host).appending(path))        return RoyGlobal.instance.addRouter(urlComponents: urlComponents!, task: task)    }    open func route<R>(path:String  , task:@escaping RoyReturnClosure<R>) -> Bool {        let urlComponents = URLComponents(string: self.scheme.appending(host).appending(path))        return RoyGlobal.instance.route(urlComponents: urlComponents!, task: task)    }}