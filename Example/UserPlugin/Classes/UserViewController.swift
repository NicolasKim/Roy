//
// Created by dreamtracer on 2018/4/1.
//

import UIKit
import Roy


class UserViewController: UIViewController,RoyProtocol,UITableViewDataSource,UITableViewDelegate {

    var color : UIColor
    var tableView : UITableView{
        get{
            let t = UITableView(frame: self.view.bounds, style: .plain)
            t.delegate = self
            t.dataSource = self
            t.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            return t
        }
    }
    var callback : (_ userInfo:Dictionary<String,Any>?,_ error:Error?)->Void

    required init?(param: [String : Any]?) {
        let type = param?["c"] as! String
		self.callback = { (userInfo,error) in
            print(userInfo,error)
        }
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
        self.view.addSubview(self.tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel!.text = "row index => \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        _ = RoyR.global.route(urlWithoutScheme: "auth/github/login", param: ["callback":self.callback])
    }
    
    
}
