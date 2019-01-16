//
//  CKSubscriptionViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class CKSubscriptionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var table:UITableView! = UITableView()
    var students = [Student]()
    public var selectPredicate = PredicateType.pall
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadData()
        CKDBManager.saveSbuscriptions()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: NSNotification.Name(rawValue: "CloudkitInfoUpdateNotification"), object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        reloadData()
    }
    
    func setupView() {
        self.title = "Students"
        let rightItem = UIBarButtonItem(
            title: "Refresh",
            style: .plain,
            target: self,
            action: #selector(action(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightItem
        
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
    }
    
    @objc func reloadData() {
        CKDBManager.checkLoginStatus { isLogged in
            if isLogged {
                self.updatData()
            } else {
                print("account unavailable")
            }
        }
    }
    
    func updatData() {
        
        CKDBManager.performQuery(selectPredicate) { records, error in
            guard let students = records else {
                self.presentMessage(error!.localizedDescription)
                return
            }
            
            self.students = students
            self.table.reloadData()
            
            guard !students.isEmpty else {
                self.presentMessage("Please add Student from the default list. Database is empty")
                return
            }
        }
    }
    
    func addStudent(_ student: Student) {
        students.insert(student, at: 0)
        table.reloadData()
    }
    
    func presentMessage(_ message: String) {
        let alertViewController = UIAlertController(title: "CloudKit", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = StudentTableViewCell.init(style: .subtitle, reuseIdentifier: "cellIdentifier")
        cell.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 180)
        let student = students[indexPath.row]
        cell.setStudent(student)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = StudentDetailsViewController()
        detail.student = students[indexPath.row]
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    @objc func action(sender: AnyObject) {
        print("Refresh")
        reloadData()
    }
}
