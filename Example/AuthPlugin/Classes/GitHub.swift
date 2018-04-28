//
// Created by dreamtracer on 2018/4/1.
//

import Foundation
import PromiseKit

class GitHub:NSObject, URLSessionDelegate {
    let client_id = "8072b903a8d64b48df87"
    let client_secret = "f6f0884773b1bedb59bdd58f37662c11045f637a"
    let networkOperationQueue = OperationQueue()
    let config = URLSessionConfiguration.default
    var loginCallBack : ((_ userInfo:Dictionary<String,Any>?,_ error:Error?)->Void)?
    let semp : DispatchSemaphore = DispatchSemaphore(value: 0)
    var userInfo : Dictionary<String,String>?
	var code     : String?
    var session:URLSession {
        get {
            return URLSession(configuration: config, delegate: self, delegateQueue: networkOperationQueue)
        }
    }

    override init(){
        super.init()
    }
    
    func login() -> Promise<Any?>{
        return firstly { () -> Promise<String> in
            return self.getCode()
        }.then { (code) -> Promise<String> in
            return self.getAccessToken(code: code)
        }.then { (token) -> Promise<Any?> in
            return self.getUserInfo(accessToken: token)
        }
    }
    
    
    
    func didCodeBack(code : String?) {
        self.code = code
        self.semp.signal()
    }
    
    

    func getCode() -> Promise<String>{
        return Promise<String>{ seal in
            if let u = URL(string: "https://github.com/login/oauth/authorize?client_id=\(client_id)&redirect_uri=roy://auth/github") {
                UIApplication.shared.openURL(u)
                DispatchQueue.global().async {
                    self.semp.wait()
                    if let u = self.code{
                        seal.fulfill(u)
                    }
                    else{
                        seal.reject(NSError(domain: "com.roy.auth", code: 500, userInfo: nil))
                    }
                }
            }
        }
    }
    
    

    
    func getAccessToken(code:String?) -> Promise<String> {
        
        return Promise<String>{ seal in
            guard let c = code else {
                seal.reject(NSError(domain: "com.roy.auth", code: 500, userInfo: nil))
                return
            }
            
            var request = URLRequest(url: URL(string:"https://github.com/login/oauth/access_token?client_id=\(client_id)&client_secret=\(client_secret)&code=\(c)&redirect_uri=roy://auth/github/callback")!)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            session.dataTask(with: request) { (data, response, error) in
                do{
                    if error == nil{
                        guard let obj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, String>,let token = obj["access_token"] else{
                            seal.reject(NSError(domain: "com.roy.auth", code: 500, userInfo: nil))
                            return
                        }
                        seal.fulfill(token)
                    }
                    else{
                        seal.reject(error!)
                    }
                }
                catch{
                    seal.reject(NSError(domain: "com.roy.auth", code: 500, userInfo: nil))
                }
                }.resume()
            }
    }
    
    func getUserInfo(accessToken:String) -> Promise<Any?>  {
        
        return Promise<Any?> { seal in
            var request = URLRequest(url: URL(string:"https://api.github.com/user?access_token=\(accessToken)")!)
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            session.dataTask(with: request) { (data, response, error) in
                do{
                    if error == nil{
                        guard let obj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, String> else{
                            seal.reject(NSError(domain: "com.roy.auth", code: 500, userInfo: nil))
                            return
                        }
                        seal.fulfill(obj)
                    }
                    else{
                        seal.reject(error!)
                    }
                }
                catch{
                    seal.reject(NSError(domain: "com.roy.auth", code: 500, userInfo: nil))
                }
            }.resume()
        }
    }
    
    

    func logout(){

    }
}

