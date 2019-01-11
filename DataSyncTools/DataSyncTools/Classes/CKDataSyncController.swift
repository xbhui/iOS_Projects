//
//  CKDataSyncController.swift
//  DataSyncTools
//
//  Created by gauss on 1/7/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit



class CKDataSyncController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
   var table:UITableView! = UITableView()
   var titles:NSArray = ["CUID API", "Query", "DataSync", "ChangeNotification"]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let api = CKObjectAPIController()
        self.navigationController?.pushViewController(api, animated: true)
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
        self.view.backgroundColor = UIColor.red
        
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableView.Style.grouped)
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
    }
}
