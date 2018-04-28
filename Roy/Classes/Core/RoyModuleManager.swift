//
//  RoyModuleManager.swift
//  GRDB.swift
//
//  Created by dreamtracer on 2018/4/28.
//

import Foundation


public class RoyModuleManager : NSObject, RoyDelegate {
   
    public static let shared = RoyModuleManager()
    
    
    private var moduleMap : [String : RoyModuleProtocol] = [:]
    private var lazyModuleMap : [String : RoyModuleProtocol.Type] = [:]
    
    override init() {
        super.init()
        RoyR.regist(delegate: self)
    }
    
    
    public func regist(module classType:RoyModuleProtocol.Type) {
        if classType.loadMode == .Immediately {
            //If the module already loaded,return
            guard let _ = self.moduleMap[classType.host] else {
                self.moduleMap[classType.host] = classType.init()
                return
            }
        }
        else{
            //If the module already loaded,return
            guard let _ = self.moduleMap[classType.host] else {
                self.lazyModuleMap[classType.host] = classType
                return
            }
        }
    }
    
    public func willRoute(url: URL, param: [String : Any]?) {
        
        guard let c = lazyModuleMap[url.host!] else { return }
        
        self.moduleMap[c.host] = c.init()
        
        lazyModuleMap.removeValue(forKey: c.host)
        
    }
    
    public func didRouted(url: URL, param: [String : Any]?, error: Error?) {
        
    }
    
}



public extension RoyModuleManager {
    
    enum RoyModuleEnum : Int {
        case Same
        case Diff
    }
    
    
    public func enumerate(callback : ( RoyModuleProtocol )->Void){
        for ( _ , value ) in self.moduleMap {
        	callback(value)
        }
    }
    
    public func enumerate(type:RoyModuleEnum = .Same, callback : ( RoyModuleProtocol )->Bool) -> Bool{
        var result = type == .Same ? true:false
        for ( _ , value ) in self.moduleMap {
            switch type{
                case .Same :
                	result = result &&  callback(value)
                case .Diff :
                	result = result || callback(value)
            }
        }
        return result
    }

    
    public func enumerate<T>(defaultValue : T, callback : ( RoyModuleProtocol )->T) -> T{
        for ( _ , value ) in self.moduleMap {
            return callback(value)
        }
        return defaultValue
    }
    
}


