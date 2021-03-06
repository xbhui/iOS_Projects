//
//  SelectStudentViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/10/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class SelectStudentViewController: UITableViewController {

    
    func presentMessage(_ message: String) {
        let alertViewController = UIAlertController(title: "CloudKit", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    var titles:NSArray = ["Tom", "Wenxin", "Dangdung", "Lucy"]
    fileprivate var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(action(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightItem
    }

    @objc func action(sender: AnyObject) {
        print("save student record")
        
        if let selectedIndexPath = tableView.indexPathsForSelectedRows?.last {
            let studentData = Student.defaultContent[selectedIndexPath.row]
            shouldAnimateIndicator(true)
            
            CKDBManager.createRecord(studentData) { record, error in
                self.shouldAnimateIndicator(false)
                if (error != nil) {
                    self.navigationController?.popViewController(animated: true)
                }else {
                 //   self.presentMessage((error?.localizedDescription ?? nil)!)
                }
            }
        }
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
        let studentName = Student.defaultContent[indexPath.row]["name"]
        cell.textLabel?.text = studentName
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        selectedIndexPath = indexPath
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        selectedIndexPath = nil
    }
    
    fileprivate func shouldAnimateIndicator(_ animate: Bool) {
        tableView.isUserInteractionEnabled = !animate
        navigationController!.navigationBar.isUserInteractionEnabled = !animate
    }
}
