//
//  TestLifeCycle.swift
//  Roy_Tests
//
//  Created by dreamtracer on 2018/3/19.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import XCTest
import Roy


class LifeCycleClass:NSObject, RoyDelegate {
    func willConvert(url:String){
        
        print(OperationQueue.current ,  #function)
    }
    func didConverted(url:String,error:Error?){
        print(OperationQueue.current ,  #function,error)
    }
    func willAdd(url:String){
        print(OperationQueue.current ,  #function)
    }
    func didAdd(url:String,error:Error?){
        print(OperationQueue.current ,  #function,error)
    }
    
    //route life cycle
    func willAnalyze(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function)
    }
    func didAnalyzed(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error)
    }
    func willValidate(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function)
    }
    func didValidated(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error)
    }
    func willFindTask(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function)
    }
    func didFoundTask(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error)
    }
    func willRoute(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function)
    }
    func didRouted(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error)
    }
}


class TestLifeCycle: XCTestCase {
    
    let queue = OperationQueue()
    var e : XCTestExpectation?
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "operations")
        {
            if (0 == self.queue.operations.count)
            {
				e!.fulfill()
            }
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func testExample() {
        
        e = expectation(description: "")
        self.queue.maxConcurrentOperationCount = 100
        
        self.queue.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions.new, context: nil)
        let lc = LifeCycleClass()
        RoyR.regist(delegate: lc)
        
        for _ in 0..<5000{
//            RoyR.global.addRouter(url: "autohome://hahahahaha/aslkdjflsa", task: { (param) -> Any in
//                return true
//            }, paramValidator: nil)
            
            RoyR.global.addRouter(url: "autohome://hahahahaha/aslkdjflsa", task: { (param) -> Any in
                return true
            }, paramValidator: nil, inQueue: self.queue)
            
        }
        
        wait(for: [e!], timeout: 10)
        
        
        
//        RoyR.global.addRouter(url: "autohome://hahahahaha/akjsdf", task: { (param) -> Any in
//            return true
//        }, paramValidator: nil)
//
//        RoyR.global.addRouter(url: "autohome://hahahahaha/akjsdf", task: { (param) -> Any in
//            return true
//        }, paramValidator: nil)
//
//        RoyR.global.addRouter(url: "autohome://hahahahaha/as", task: { (param) -> Any in
//            return true
//        }, paramValidator: nil)
//
//        RoyR.global.addRouter(url: "autohome://hahahahaha/asd", task: { (param) -> Any in
//            return true
//        }, paramValidator: nil)
//
//        RoyR.global.addRouter(url: "autohome://hahahahaha/qieriqwer", task: { (param) -> Any in
//            return true
//        }, paramValidator: nil)
//
//
//        RoyR.global.addRouter(url: "autohome://hahahahaha", task: { (param) -> Any in
//            return true
//        }, paramValidator: nil)
        
        
        
        
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
