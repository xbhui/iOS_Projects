//
//  StudentDetailsViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/10/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
private let kUpdatedMessage = "Student has been updated successfully"
private let kRemoveMessage = "Student has been removed successfully"


class StudentDetailsViewController: UIViewController {
    
    func presentMessage(_ message: String) {
        let alertViewController = UIAlertController(title: "CloudKit", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertViewController.addAction(okAction)
        present(alertViewController, animated: true, completion: nil)
    }
    
    var student: Student!
    
    private var scrollView: UIScrollView!
    private var studentImageView: UIImageView!
    private var nameLabel: UILabel!
    private var gradeLabel: UILabel!
    private var removeBtn: UIButton!
    private var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightItem = UIBarButtonItem(
            title: "Save",
            style: .plain,
            target: self,
            action: #selector(saveButtonDidPress(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightItem
        
        setupView()
        NotificationCenter.default.addObserver(self, selector:#selector(StudentDetailsViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.white
        scrollView = UIScrollView.init(frame: UIScreen.main.bounds)
        
        studentImageView = UIImageView.init(frame: CGRect.init(x: 20, y: 20, width: UIScreen.main.bounds.width-40, height: 150))
        studentImageView.image = student.image
        scrollView.addSubview(studentImageView)
        
        nameLabel = UILabel.init(frame: CGRect.init(x: 20, y: 20 + 180, width: 80, height: 30))
        nameLabel.text = student.name
        nameLabel.textAlignment = .left
        scrollView.addSubview(nameLabel)
        
        removeBtn = UIButton.init(type: .roundedRect)
        removeBtn.frame = CGRect.init(x: UIScreen.main.bounds.width - 20-80, y: 20 + 180, width: 80, height: 30)
        removeBtn.setTitle("Remove", for: .normal)
        removeBtn.titleLabel?.textAlignment = .right
        removeBtn.setTitleColor(UIColor.black, for: .normal)
        removeBtn.addTarget(self, action: #selector(removeButtonDidPress(sender:)), for: .touchUpInside)
        scrollView.addSubview(removeBtn)
        
        gradeLabel = UILabel.init(frame: CGRect.init(x: 100, y: 20 + 180, width: UIScreen.main.bounds.width - 180, height: 30))
        gradeLabel.text = student.avggrade
        gradeLabel.textAlignment = .center
        scrollView.addSubview(gradeLabel)
        
        descriptionTextView = UITextView.init(frame: CGRect.init(x: 20, y: 20+180+30+20, width: UIScreen.main.bounds.width-40, height: 200))
        descriptionTextView.text = student.text
        scrollView.addSubview(descriptionTextView)
        
        self.view.addSubview(scrollView)
    }
    
    func shouldAnimateIndicator(_ animate: Bool) {
        self.view.isUserInteractionEnabled = !animate
        self.navigationController!.navigationBar.isUserInteractionEnabled = !animate
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        let keyboardSize = ((notification as NSNotification).userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)!.cgRectValue
        
        let keyboardHeight = keyboardSize.height
        let contentOffsetX = self.scrollView.contentOffset.x
        let contentOffsetY = self.scrollView.contentOffset.y

        self.scrollView.contentOffset = CGPoint(x: contentOffsetX, y: contentOffsetY + keyboardHeight)
    }
    
    @objc func saveButtonDidPress(sender: AnyObject) {
        view.endEditing(true)
        
        let identifier = student.identifier
        let updatedText = descriptionTextView.text!
        
        shouldAnimateIndicator(true)
        CKDBManager.updateRecord(identifier, text: updatedText) { record, error in
            self.shouldAnimateIndicator(false)
            if let error = error {
                self.presentMessage(error.localizedDescription)
            } else if let record = record {
                self.student.text = record.value(forKey: stext) as! String
                self.presentMessage(kUpdatedMessage)
            }
        }
    }
    
   @objc func removeButtonDidPress(sender: AnyObject) {
        self.shouldAnimateIndicator(true)
        CKDBManager.removeRecord(student.identifier) { recordId, error in
            self.shouldAnimateIndicator(false)
            
            if let error = error {
                self.presentMessage(error.localizedDescription)
            } else {
                self.presentMessage(kRemoveMessage)

            }
        }
    }
}
