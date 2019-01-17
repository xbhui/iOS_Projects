//
//  CKDataSyncController.swift
//  DataSyncTools
//
//  Created by gauss on 1/7/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

enum row: NSInteger {
    case one = 0
    case two = 1
    case three = 2
    case four  = 3
}


class CKDataSyncController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
   var table:UITableView! = UITableView()
   var titles:NSArray = ["CRUD API", "Query", "Conflict Resolution", "Subscription"]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == row.one.rawValue) {
            let api = CKCRUDAPIController()
            self.navigationController?.pushViewController(api, animated: true)
        }else if(indexPath.row == row.two.rawValue) {
            let query = CKQueryViewController()
            self.navigationController?.pushViewController(query, animated: true)
        }else if(indexPath.row == row.three.rawValue) {
            let conflict = CKConflictViewController()
            self.navigationController?.pushViewController(conflict, animated: true)
        }else if(indexPath.row == row.four.rawValue) {
            let sub = CKSubscriptionViewController()
            self.navigationController?.pushViewController(sub, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        cell.textLabel?.textAlignment = NSTextAlignment.left
        cell.textLabel?.text = String?(titles[indexPath.row] as! String)
        cell.accessoryType = UITableViewCell.AccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Cloudkit"
       // self.view.backgroundColor = UIColor.red
        
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableView.Style.grouped)
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
