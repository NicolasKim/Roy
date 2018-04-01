//
// Created by dreamtracer on 2018/4/1.
//

import UIKit
import Roy
import SnapKit

class UserHeaderView: UIView {
    
    private var avatarView : UIImageView?
    private var nickNameLabel : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        avatarView = UIImageView(frame: CGRect.zero)
        avatarView?.translatesAutoresizingMaskIntoConstraints = false
        avatarView?.backgroundColor = UIColor.black
        nickNameLabel = UILabel(frame: CGRect.zero)
        nickNameLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(avatarView!)
        self.addSubview(nickNameLabel!)
        avatarView?.snp.makeConstraints({ (make) in
            make.width.equalTo(64)
            make.height.equalTo(64)
            make.top.equalTo(50)
            make.centerX.equalTo(self.snp.centerX)
        })

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class UserViewController: UIViewController,RoyProtocol,UITableViewDataSource,UITableViewDelegate {

    var color : UIColor
    var tableView : UITableView?
    var headerView : UserHeaderView?

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
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        
        self.headerView = UserHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 164))
        self.tableView?.tableHeaderView = self.headerView
        self.view.addSubview(self.tableView!)
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
        _ = RoyR.global.route(urlWithoutScheme: "auth/github/login", param: ["callback":{ (userInfo,error) in
            	print(userInfo,error)
            }])
    }
    
    
}
