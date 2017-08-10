//
//  SecondViewController.swift
//  Roy
//
//  Created by 金秋成 on 2017/8/10.
//  Copyright © 2017年 CocoaPods. All rights reserved.
//

import UIKit
import Roy


class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.red;
        
        _ = self.roy.addRouter(scheme: "changecolor") { (c : UIColor) -> Bool in
            self.view.backgroundColor = c
            return true
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
