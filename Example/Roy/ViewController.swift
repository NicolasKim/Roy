//
//  ViewController.swift
//  Roy
//
//  Created by jinqiucheng1006@live.cn on 08/10/2017.
//  Copyright (c) 2017 jinqiucheng1006@live.cn. All rights reserved.
//

import UIKit
import Roy


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.brown
        
        let v = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
//        _ = RoyGlobal.instance.route(url: "opensecond", param: "asdfsdf") { (r : UIViewController) -> (Void) in
//            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
//                _ = self.present(r, animated: true, completion: {
//                    _ = r.roy.route(url: "changecolor", param: UIColor.blue, task: { (r : Bool) -> (Void) in
//                        
//                    })
//                });
//            })
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    
    
}

