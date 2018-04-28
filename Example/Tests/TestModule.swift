//
//  TestModule.swift
//  Roy_Tests
//
//  Created by dreamtracer on 2018/4/28.
//  Copyright © 2018年 CocoaPods. All rights reserved.
//

import XCTest
import Roy
import PromiseKit

class Module1: RoyModuleProtocol {
    
    static var host : String {
        get {
            return "module1"
        }
    }
    
    static var loadMode : RoyModuleLoadMode {
        get {
        	return .Lazily
        }
    }
    
    required init() {
        
        self.addRouter(path: "modulepath", paramValidator: nil) { param in
            return Promise<String>{ seal in
                seal.fulfill("return value")
            }
        }
        
        self.addRouter(path: "modulepath1", paramValidator: nil) { param in
            return Promise<String>{ seal in
                seal.fulfill("return value1")
            }
        }
        
        self.addRouter(path: "modulepath2", paramValidator: nil) { param in
            return Promise<String>{ seal in
                seal.fulfill("return value2")
            }
        }
    }
}

class Module2: RoyModuleProtocol {
    
    static var host : String {
        get {
            return "module2"
        }
    }
    
    static var loadMode : RoyModuleLoadMode {
        get {
            return .Lazily
        }
    }
    
    required init() {
        
        self.addRouter(path: "modulepath", paramValidator: nil) { param in
            return Promise<String>{ seal in
                seal.fulfill("return value")
            }
        }
        
        self.addRouter(path: "modulepath1", paramValidator: nil) { param in
            return Promise<String>{ seal in
                seal.fulfill("return value1")
            }
        }
        
        self.addRouter(path: "modulepath2", paramValidator: nil) { param in
            return Promise<String>{ seal in
                seal.fulfill("return value2")
            }
        }
    }
}






class TestModule: XCTestCase {
    
    override func setUp() {
        super.setUp()
        RoyModuleConfig.shared.scheme = "roy"
        RoyModuleManager.shared.regist(module: Module2.self)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let m1 = Module1()
        
        let exception = self.expectation(description: "time")
        
        _ =
        firstly{
            return m1.route(host: "module2", path: "modulepath", param: nil).done { (str : String) in
                print(str)
            }
        }.then {
            return m1.route(host: "module1", path: "modulepath1", param: nil).done { (str : String) in
                print(str)
            }
        }.then{
            return m1.route(host: "module1", path: "modulepath2", param: nil).done { (str : String) in
                print(str)
            }
        }
        .done {
            exception.fulfill()
        }
        
        self.waitForExpectations(timeout: 10) { (error) in
            
        }
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
