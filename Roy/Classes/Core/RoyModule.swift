
    func route(path:String ,param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool
    
    func addRouter(path:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool

public extension RoyModuleProtocol{
    public func addRouter(path:String , task:@escaping RoyTaskClosure,paramValidator:RoyValidatorProtocol.Type?) -> Bool {
    	let urlString = "\(self.scheme)://\(moduleHost)/\(path)"
    	return RoyR.global.addRouter(url: urlString, task: task, paramValidator: paramValidator)
    }
    
    public func route(path:String ,param : [String:Any]?  , task:@escaping RoyReturnClosure) -> Bool {
    	let urlString = "\(self.scheme)://\(moduleHost)/\(path)"
    	let url = URL(string: urlString)
    	return RoyR.global.route(url: url!, param: param, task: task)
    }
}
