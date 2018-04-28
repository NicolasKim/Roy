//
// Created by dreamtracer on 2018/4/1.
//

import UIKit
import Roy
import SnapKit
import PromiseKit


enum UVType : String {
    case LoginUser    =    "kUVTypeLoginUser"
    case OtherUser    =    "kUVTypeOtherUser"
    case GuestUser    =    "kUVTypeGuestUser"
}


enum UVRowType : String {
    case Login    =    "kUVRowTypeLogin"
    case Logout    =    "kUVRowTypeLogout"
    case Repo    =    "kUVRowTypeRepo"
    case Fork    =    "kUVRowTypeFork"
    case Star    =    "kUVRowTypeStar"
    case Watch    =    "kUVRowTypeWatch"
}

struct UVRowModel{
    var rowType : UVRowType
    
}



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


class UVLoginOutCell: UITableViewCell {
    
    var titleLabel : UILabel = UILabel(frame: CGRect.zero)
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.textAlignment = .center
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = self.contentView.bounds;
    }

}

class UVHeaderFooterView: UITableViewHeaderFooterView {
    
}




class UserViewController: UIViewController,RoyProtocol,UITableViewDataSource,UITableViewDelegate {

    var color : UIColor
    var tableView : UITableView?
    var headerView : UserHeaderView?
	private var rowData:[[UVRowType]] = []
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
        
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        self.tableView?.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self

        self.headerView = UserHeaderView(frame: CGRect.zero)
        self.tableView?.tableHeaderView = self.headerView
        self.tableView?.register(UVHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "headerfooter")
        self.view.addSubview(self.tableView!)
        
        
        self.resetRowData()
        
        self.tableView?.reloadData()
        
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.headerView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 164);
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = self.rowData[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: key.rawValue, for: indexPath)
        switch key {
        case UVRowType.Login:
            if let c = cell as? UVLoginOutCell{
                c.titleLabel.text = "Login"
            }
        case UVRowType.Logout:
            if let c = cell as? UVLoginOutCell{
                c.titleLabel.textColor = UIColor.red
                c.titleLabel.text = "Logout"
            }
        case UVRowType.Repo:
            cell.textLabel?.text = "Repository"
        case UVRowType.Fork:
            cell.textLabel?.text = "Fork"
        case UVRowType.Watch:
            cell.textLabel?.text = "Watch"
        case UVRowType.Star:
            cell.textLabel?.text = "Star"

        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowData[section].count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.rowData.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerfooter"){
            return headerFooter
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let headerFooter = tableView.dequeueReusableHeaderFooterView(withIdentifier: "headerfooter"){
            return headerFooter
        }
        return nil
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = self.rowData[indexPath.section][indexPath.row]
        switch key {
        case UVRowType.Login:
            self.login()
        case UVRowType.Logout:
            fallthrough;
        case UVRowType.Repo:
            fallthrough;
        case UVRowType.Fork:
            fallthrough;
        case UVRowType.Watch:
            fallthrough;
        case UVRowType.Star:
            print("asdf")
            
        }
        
        
    }
    
    
    
    
    func resetRowData() {
        self.rowData.removeAll()
        if self.isUserLogin {
            //TODO:构建登录用户UI数据
            self.rowData.append(contentsOf: [[.Repo,.Fork,.Star,.Watch],[.Logout]])
        }
        else{
            //TODO:构建未登录用户UI数据
            self.rowData.append(contentsOf: [[.Login]])
        }

        //注册cell
        for sType in self.rowData {
            for rType in sType{
                switch rType {
                case .Login:fallthrough;
                case .Logout:
                    self.tableView?.register(UVLoginOutCell.self, forCellReuseIdentifier: rType.rawValue)
                default:
                    self.tableView?.register(UITableViewCell.self, forCellReuseIdentifier: rType.rawValue)
                }
            }
        }
    }
    
    var isUserLogin : Bool {
        get{
            //TODO:判断用户登录
            return false
        }
    }
    
    func login() {
//        RoyR.global.route(urlWithoutScheme: "auth/github/login", param: nil) { (result) in
//
//        }
        
        RoyR.global.route(urlWithoutScheme: "auth/github/login", param: nil).done { promise in
			if let p = promise as? Promise<Dictionary<String,String>>{
                p.done({ (value) in
                    print(value)
                }).catch({ (e) in
                    print(e)
                })
            }
        }


    }
}
