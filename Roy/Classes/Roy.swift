//
//  RoyR.swift
//  Pods
//
//  Created by 金秋成 on 2017/8/10.
//
//

import UIKit

typealias RoyTaskClosure = (Any)->(Any)

class RoyR: NSObject {
   
    fileprivate var schemeTaskMap : [String:RoyTaskClosure] = [:]
    
    func addRouter(scheme:String , task:@escaping RoyTaskClosure) -> Bool {
        self.schemeTaskMap[scheme] = task
        
        return true
    }
}
