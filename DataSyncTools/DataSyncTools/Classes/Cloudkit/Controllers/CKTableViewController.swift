//
//  CKTableViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/11/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class CKTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var titles: NSArray = []
    var cellHeight = CGFloat()
    
    var table:UITableView! = UITableView()
    func createCell(indexPath: IndexPath)->(UITableViewCell){ return UITableViewCell()}
    func pushNextPage(indexPath: IndexPath){}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        pushNextPage(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCell(indexPath: indexPath)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: UITableView.Style.grouped)
        table.dataSource = self
        table.delegate = self
        self.view.addSubview(table)
    }
}
