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

        self.setViewControllers(urls: [URL(string: "Roy://testmodule/hahaha?c=1")!,
                                       URL(string: "Roy://testmodule/hahaha?c=2")!,
                                       URL(string: "Roy://testmodule/hahaha?c=3")!,
                                       URL(string: "Roy://testmodule/hahaha?c=4")!],
                                animated: true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
