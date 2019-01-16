//
//  SelectQueyFilterViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/13/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class SelectQueyFilterViewController: UITableViewController {
    
    
    func presentMessage(_ message: String) {
        let alertViewController = UIAlertController(title: "CloudKit", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    var titles:NSArray = ["All", "Name = Sam", "Grade > 80", "Sort by avggrade"]
    fileprivate var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        cell.frame =  CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        cell.textLabel?.text = String?(titles[indexPath.row] as! String)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        
        let vcindex = self.navigationController?.viewControllers.count
        
        print("vc_count:%d",vcindex!-1)
        
    //    var queryvc = (CKQueryViewController)()
//       let queryvc = (CKQueryViewController)self.navigationController?.viewControllers[vcindex-1]
//
//        queryvc.selectPredicate = indexPath.row
//
        
  //      self.navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
    
    fileprivate func shouldAnimateIndicator(_ animate: Bool) {
        tableView.isUserInteractionEnabled = !animate
        navigationController!.navigationBar.isUserInteractionEnabled = !animate
    }

}
