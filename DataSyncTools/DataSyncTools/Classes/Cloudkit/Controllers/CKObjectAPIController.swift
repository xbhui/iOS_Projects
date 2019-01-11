//
//  CKObjectAPIController.swift
//  DataSyncTools
//
//  Created by gauss on 1/9/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import CloudKit


class CKObjectAPIController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var table:UITableView! = UITableView()
    var students = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        reloadData()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.yellow
        self.title = "Students"
        
        let rightItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(action(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightItem
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        table.backgroundColor = UIColor.yellow
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
    }

    @objc func action(sender: AnyObject) {
        print("and student record")
        let selectController = SelectStudentViewController()
        self.navigationController?.pushViewController(selectController, animated: true)
    }
    
    func reloadData() {
        CKDBManager.checkLoginStatus { isLogged in
          //  self.shouldAnimateIndicator(false)
            if isLogged {
                self.updatData()
            } else {
                print("account unavailable")
            }
        }
    }
    func updatData() {
        
        CKDBManager.fetchAllStudents { records, error in
            
            guard let students = records else {
                self.presentMessage(error!.localizedDescription)
                return
            }
            
            guard !students.isEmpty else {
                self.presentMessage("Add Student from the default list. Database is empty")
                return
            }
            
            self.students = students
            self.table.reloadData()
        }
    }
    
    func addStudent(_ student: Student) {
        students.insert(student, at: 0)
        table.reloadData()
    }
    
    func removeStudent(_ studentToRemove: Student) {
        students = students.filter { currentStu in
            return currentStu != studentToRemove
        }
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
}

