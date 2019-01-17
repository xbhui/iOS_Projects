//
//  CKQueryViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/13/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class CKQueryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var table:UITableView! = UITableView()
    var students = [Student]()
    public var selectPredicate = PredicateType.pall
    
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
        self.title = "Students"
        let rightItem = UIBarButtonItem(
            title: "Filter",
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

    func reloadData() {
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
        detail.frompage = FromPage.fpquery
        self.navigationController?.pushViewController(detail, animated: true)
    }
 
    
    @objc func action(sender: AnyObject) {
        print("Query by Filter")
        //    let selectController = SelectQueyFilterViewController()
        //   self.navigationController?.pushViewController(selectController, animated: true)
        
        let alertview:UIAlertController = UIAlertController(title: "Please select prdicate", message: nil, preferredStyle: .actionSheet)
        
        let alertAction1:UIAlertAction = UIAlertAction(title: "All", style: .default, handler: { (action:UIAlertAction) -> Void in
            print ( "All" )
            self.selectPredicate = PredicateType.pall
            self.reloadData()
        })
        
        let alertAction2 : UIAlertAction = UIAlertAction (title:  "Name = Sam" , style: .default, handler: { (action: UIAlertAction ) -> Void in
            print ( "Name = Sam" )
            self.selectPredicate = PredicateType.pname
            self.reloadData()
        })
        
        let alertAction3 : UIAlertAction = UIAlertAction (title:  "Grade > 90" , style: .default, handler: { (action: UIAlertAction ) -> Void in
            print ( "Grade > 80" )
              self.selectPredicate = PredicateType.pgrade
            self.reloadData()
        })
        
        let alertAction4 : UIAlertAction = UIAlertAction (title:  "Sort by avggrade" , style: .default, handler: { (action: UIAlertAction ) -> Void in
            print ( "Sort by avggrade" )
            self.selectPredicate = PredicateType.sort
            self.reloadData()
        })
        
        let alertAction5 : UIAlertAction = UIAlertAction (title:  "Cancle" , style: .cancel, handler: { (action: UIAlertAction ) -> Void in
            print ( "Cancle" )
        })
        
        alertview.addAction(alertAction1)
        alertview.addAction(alertAction2)
        alertview.addAction(alertAction3)
        alertview.addAction(alertAction4)
        alertview.addAction(alertAction5)
        
        self.present( alertview , animated: true, completion: { () -> Void in
            print ( " alertview" )
        })
        
    }
}
