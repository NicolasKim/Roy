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
                urlsWithoutScheme: ["user/hahaha?c=1",
                                    "user/hahaha?c=2",
                                    "user/hahaha?c=3",
                                    "user/hahaha?c=4"],
                animated: true
        )
        _ = self.roy.addRouter(urlWithoutScheme: "platform/tabbar/index?i=<number>", paramValidator: nil) { params in
            if let p = params , let i = p["i"] as? String  {
                self.selectedIndex =  Int(i)!
            }
            return nil
        }

        self.perform(#selector(selectIndex), with: nil, afterDelay: 2)

    }

    @objc
    func selectIndex() {
        _ = self.roy.route(urlWithoutScheme: "platform/tabbar/index?i=1", param: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
