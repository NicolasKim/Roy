import UIKit
import XCTest
import Roy
import PromiseKit

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
        let exception = self.expectation(description: "time")
        
        
        RoyR.global.addRouter(url: "roy://host/path", paramValidator: nil) { param in
            return Promise<UIViewController>{ seal in
                seal.fulfill(UIViewController(nibName: nil, bundle: nil))
            }
		}

	   	RoyR.global.addRouter(url: "roy://host/path2", paramValidator: nil, task: { param in
            return Promise<String>{ seal in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(5) , execute: {
                    seal.fulfill("long time no see")
                })
            }
        })
        
        RoyR.global.addRouter(url: "roy://host/path2", paramValidator: nil, task: { param in
            return Promise<String>{ seal in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(5) , execute: {
                    seal.fulfill("long time no see")
                })
            }
        })
        
        RoyR.global.addRouter(url: "roy://host/path3", paramValidator: nil, task: { param in
            return Promise<String>{ seal in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(5) , execute: {
                    seal.fulfill("long time no see")
                })
            }
        })
        
        RoyR.global.addRouter(url: "roy://host/path5", paramValidator: nil, task: { param in
            return Promise<String>{ seal in
                DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + .seconds(5) , execute: {
                    seal.fulfill("long time no see")
                })
            }
        })
        
        RoyR
            .global
            .route(url: URL(string: "roy://host/path2")!, param: nil, in: DispatchQueue.global())
            .done{ (str : String) in
                print(str)
                exception.fulfill()
        }
        
        
        self.waitForExpectations(timeout: 10) { (error) in
            
        }
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
