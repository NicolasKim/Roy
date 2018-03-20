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
        
        print(OperationQueue.current ,  #function ,url)
    }
    func didConverted(url:String,error:Error?){
        print(OperationQueue.current ,  #function,error,url)
    }
    func willAdd(url:String){
        print(OperationQueue.current ,  #function,url)
    }
    func didAdd(url:String,error:Error?){
        print(OperationQueue.current ,  #function,error,url)
    }
    
    //route life cycle
    func willAnalyze(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function,url)
    }
    func didAnalyzed(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error,url)
    }
    func willValidate(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function,url)
    }
    func didValidated(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error,url)
    }
    func willFindTask(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function,url)
    }
    func didFoundTask(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error,url)
    }
    func willRoute(url:URL,param:[String:Any]?){
        print(OperationQueue.current ,  #function,url)
    }
    func didRouted(url:URL,param:[String:Any]?,error:Error?){
        print(OperationQueue.current ,  #function,error,url)
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
//                e!.fulfill()
            }
        }
        else
        {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    
    func testExample() {

        self.queue.maxConcurrentOperationCount = 100
        
        self.queue.addObserver(self, forKeyPath: "operations", options: NSKeyValueObservingOptions.new, context: nil)
        let lc = LifeCycleClass()
        RoyR.regist(delegate: lc)
    }
    
    
    func testRegist() {
        //7.398s
        for _ in 0..<5000{
            _ = RoyR.global.addRouter(url: "autohome://hahahahaha/aslkdjflsa", paramValidator: nil, task: { (param) -> Any? in
                return nil
            })
        }
    }
    
    
    func testRoute() {
//        11.612
        for _ in 0..<5000{
            _ = RoyR.global.route(url: URL(string: "autohome://hahahahaha/aslkdjflsa")!, param: nil)
        }
    }
    
    
    func testLifeCircle(){
        _ = RoyR.global.addRouter(url: "autohome://hahahahaha/aslkdjflsa", paramValidator: nil, task: { (param) -> Any? in
            return nil
        })
        
        _ = RoyR.global.addRouter(url: "autohome://hahahahaha/aslkda?h=<number?>", paramValidator: nil, task: { (param) -> Any? in
            return nil
        })
        
        _ = RoyR.global.addRouter(url: "autohome://hahahahaha/kda?h=<number>", paramValidator: nil, task: { (param) -> Any? in
            return nil
        })
        
        
        _ = RoyR.global.addRouter(url: "autohome://hahahahaha/qwer?h=<text>", paramValidator: nil, task: { (param) -> Any? in
            return nil
        })
        
        _ = RoyR.global.addRouter(url: "autohome://hahahah123", paramValidator: nil, task: { (param) -> Any? in
            return nil
        })
        
        
        _ = RoyR.global.route(url: URL(string: "autohome://hahahahaha/aslkdjflsa")!, param: nil)
        _ = RoyR.global.route(url: URL(string: "autohome://hahahahaha/aslkda?h=123")!, param: nil)
        _ = RoyR.global.route(url: URL(string: "autohome://hahahahaha/kda?h=456")!, param: nil)
        _ = RoyR.global.route(url: URL(string: "autohome://hahahahaha/qwer?h=kkk")!, param: nil)
        _ = RoyR.global.route(url: URL(string: "autohome://hahahah123")!, param: nil)
        
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
