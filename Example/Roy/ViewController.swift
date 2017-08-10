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
        _ = RoyGlobal.instance.route(scheme: "opensecond", param: "asdfsdf") { (r : UIViewController) -> (Void) in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: { 
                _ = self.present(r, animated: true, completion: {
                    _ = r.roy.route(scheme: "changecolor", param: UIColor.blue, task: { (r : Bool) -> (Void) in
                        
                    })
                });
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    
    
    
    
}

