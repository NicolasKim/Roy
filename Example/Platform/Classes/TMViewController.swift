//
//  TMViewController.swift
//  TestModule
//
//  Created by 金秋成 on 2017/8/17.
//  Copyright © 2017年 DreamTracer. All rights reserved.
//

import UIKit
import Roy


class TMViewController: UITabBarController,RoyProtocol {

    required init?(param : [String:Any]?){
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setViewControllers(
                urlsWithoutScheme: ["user/main?c=1",
                                    "user/main?c=1"],
                animated: true
        )
        _ = self.roy.addRouter(urlWithoutScheme: "platform/tabbar/index?i=<number>", paramValidator: nil) { params in
            if let p = params , let i = p["i"] as? String  {
                self.selectedIndex =  Int(i)!
            }
            return nil
        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
