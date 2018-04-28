//
//  RoyModule.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/4/27.
//

import Foundation
import PromiseKit


public class RoyModuleConfig {
    
    public var scheme : String?
    
    public static let shared = RoyModuleConfig()
    
    
    func getFullURL(host:String,path:String) -> URL {
        assert(scheme != nil, "set scheme before you invoke this function")
        return URL(string: "\(scheme!)://\(host)/\(path)")!
    }
    
    func getFullURL(urlWithoutScheme:String) -> URL {
        assert(scheme != nil, "set scheme before you invoke this function")
        return URL(string: "\(scheme!)://\(urlWithoutScheme)")!
    }
}


public enum RoyModuleLoadMode : String {
    case Immediately = "eRoyModuleLoadModeImmediately"
    case Lazily      = "eRoyModuleLoadModeLazily"
}


public protocol RoyModuleProtocol {
    
    static var host : String { get }

    static var loadMode : RoyModuleLoadMode { get }
    
    init()
	
}


extension RoyModuleProtocol{
    
    public func route<T>(host:String,path:String, param:[String:Any]? ,in queue:DispatchQueue?)->Promise<T>{
        let url = RoyModuleConfig.shared.getFullURL(host: host, path: path)
        return RoyR.global.route(url: url, param: param, in: queue)
    }
    
    public func route<T>(host:String,path:String, param:[String:Any]?)->Promise<T>{
        let url = RoyModuleConfig.shared.getFullURL(host: host, path: path)
        return RoyR.global.route(url: url, param: param, in: nil)
    }
    
    public func route<T>(urlWithoutScheme:String, param:[String:Any]?, in queue:DispatchQueue?)->Promise<T>{
        let url = RoyModuleConfig.shared.getFullURL(urlWithoutScheme: urlWithoutScheme)
        return RoyR.global.route(url: url, param: param, in: queue)
    }
	
    public func route<T>(urlWithoutScheme:String, param:[String:Any]?)->Promise<T>{
        let url = RoyModuleConfig.shared.getFullURL(urlWithoutScheme: urlWithoutScheme)
        return RoyR.global.route(url: url, param: param, in: nil)
    }
    
    public func addRouter<T>(path:String, paramValidator: RoyValidatorProtocol.Type?, task: @escaping RoyTaskClosure<T>){
        assert(RoyModuleConfig.shared.scheme != nil, "set scheme before you invoke this function")
        let url = "\(RoyModuleConfig.shared.scheme!)://\(Self.host)/\(path)"
        RoyR.global.addRouter(url: url, paramValidator: paramValidator, task: task)
    }

}
