//
// Created by dreamtracer on 2018/4/1.
//

import Foundation


class GitHub:NSObject, URLSessionDelegate {
    let client_id = "8072b903a8d64b48df87"
    let client_secret = "f6f0884773b1bedb59bdd58f37662c11045f637a"
    let networkOperationQueue = OperationQueue()
    let config = URLSessionConfiguration.default
    var loginCallBack : ((_ userInfo:Dictionary<String,Any>?,_ error:Error?)->Void)?

    var session:URLSession {
        get {
            return URLSession(configuration: config, delegate: self, delegateQueue: networkOperationQueue)
        }
    }

    override init(){
        super.init()
    }


    func login(callback:@escaping (_ userInfo:Dictionary<String,Any>?,_ error:Error?)->Void){
        self.loginCallBack = callback
        if let u = URL(string: "https://github.com/login/oauth/authorize?client_id=\(client_id)&redirect_uri=roy://auth/github") {
            UIApplication.shared.openURL(u)
        }
    }

    
    func getAccessToken(code:String?,callback:@escaping (_ accessToken:String?,_ error:Error?)->Void) {
        guard let c = code else {
            callback(nil, NSError(domain: "com.roy.authplugin.getaccesstoken", code: -1, userInfo: nil))
            return
        }
        
        var request = URLRequest(url: URL(string:"https://github.com/login/oauth/access_token?client_id=\(client_id)&client_secret=\(client_secret)&code=\(c)&redirect_uri=roy://auth/github/callback")!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request) { (data, response, error) in
            do{
                if error == nil{
                    guard let obj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, String>,let token = obj["access_token"] else{
                        return
                    }
                    
                    if let cb = self.loginCallBack{
                        self.getUserInfo(accessToken: token, callback: { (result, error) in
                            DispatchQueue.main.async {
                                cb(result, error)
                            }
                        })
                    }
                    callback(token, nil)
                }
                else{
                    callback(nil, error!)
                }
            }
            catch{
               callback(nil, NSError(domain: "com.roy.authplugin.getaccesstoken", code: -1, userInfo: nil))
            }
        }.resume()
        
    }
    
    func getUserInfo(accessToken:String,callback:@escaping (_ userInfo:Dictionary<String,Any>?,_ error:Error?)->Void) {
        var request = URLRequest(url: URL(string:"https://api.github.com/user?access_token=\(accessToken)")!)
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        session.dataTask(with: request) { (data, response, error) in
            do{
                if error == nil{
                    guard let obj = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as? Dictionary<String, Any> else{
                        return
                    }
                    callback(obj, nil)
                }
                else{
                    callback(nil, error!)
                }
            }
            catch{
                callback(nil, NSError(domain: "com.roy.authplugin.getuserinfo", code: -1, userInfo: nil))
            }
        }.resume()
    }
    
    

    func logout(){

    }
}

