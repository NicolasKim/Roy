//
//  FirstViewController.swift
//  TestModule
//
//  Created by 金秋成 on 2017/8/17.
//  Copyright © 2017年 DreamTracer. All rights reserved.
//

import UIKit

import Roy

class FirstViewController: UIViewController,RoyCreationProtocol {

    var color : UIColor
    
    required init?(param: [String : Any]?) {
        let type = param?["c"] as! String
        
        switch type {
        case "1":
            color = UIColor.red
        case "2":
            color = UIColor.brown
        case "3":
            color = UIColor.gray
        case "4":
            color = UIColor.purple
        default:
            color = UIColor.black
        }

        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = color
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
