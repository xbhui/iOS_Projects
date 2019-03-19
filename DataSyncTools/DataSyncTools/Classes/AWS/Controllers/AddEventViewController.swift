//
//  AddEventViewController.swift
//  DataSyncTools
//
//  Created by gauss on 2/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import AWSAppSync


class AddEventViewController: UIViewController {
    
    var nameInput: UITextField!
    var descriptionInput: UITextField!
    var whenInput: UITextField!
    var whereInput: UITextField!
    
    // MARK: - Variables
    var appSyncClient: AWSAppSyncClient?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        setupView()
        
        // Do any additional setup after loading the view.
    }
    
    func setupView() {
        
      self.view.backgroundColor = UIColor.white
      addLabel(toporign: 100, txt: "Name")
      addLabel(toporign: 130, txt: "Description")
      addLabel(toporign: 160, txt: "When")
      addLabel(toporign: 190, txt: "Where")
      nameInput = addTextFeild(toporign: 100);
      descriptionInput = addTextFeild(toporign: 130);
      whenInput = addTextFeild(toporign: 160);
      whereInput = addTextFeild(toporign: 190);
        
      let addEventbtn = addButton(toporign: 220+80, title: "Add Event")
      addEventbtn.addTarget(self, action: #selector(addNewEvent(sender:)), for: .touchUpInside)
      self.view.addSubview(addEventbtn);
        
      let removeEventbtn = addButton(toporign: 220+80+40, title: "Cancle")
      removeEventbtn.addTarget(self, action: #selector(cancleAction(sender:)), for: .touchUpInside)
      self.view.addSubview(removeEventbtn);
    }
    
    func addLabel(toporign:CGFloat, txt:String){
        let lab = UILabel(frame: CGRect(x: 20, y: toporign, width:  80, height: 30))
        lab.backgroundColor = UIColor.white
        lab.textColor = UIColor.black
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textAlignment = .left
        lab.text = txt
        self.view.addSubview(lab)
    }
    func addTextFeild(toporign:CGFloat)->(UITextField) {
        
        let textField = UITextField.init(frame: CGRect(x: 130, y: toporign, width:  UIScreen.main.bounds.width-30-130, height: 30))
        textField.backgroundColor = UIColor.white
        self.view.addSubview(textField)
        return textField
    }
    
    func addButton(toporign:CGFloat, title:String)->(UIButton) {
        
        let btn = UIButton.init(type: .roundedRect)
        btn.frame = CGRect.init(x: 0, y: toporign, width:UIScreen.main.bounds.width , height: 40)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.setTitleColor(UIColor.black, for: .normal)
        return btn;
    }
    
//Mark add new event
    @objc func addNewEvent(sender: AnyObject) {
            guard let nameText = nameInput.text, !nameText.isEmpty,
            let whenText = whenInput.text, !whenText.isEmpty,
            let whereText = whereInput.text, !whereText.isEmpty,
            let descriptionText = descriptionInput.text, !descriptionText.isEmpty else {
                // Server won't accept empty strings
                let alertController = UIAlertController(title: "Error", message: "Missing values.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertController.addAction(okAction)
                present(alertController, animated: true)
                
                return
        }
        
        // We set up a temporary ID so we can reconcile the server-provided ID when `addEventMutation` returns
        let temporaryLocalID = "TEMP-\(UUID().uuidString)"
        
        let addEventMutation = AddEventMutation(name: nameText,
                                                when: whenText,
                                                where: whereText,
                                                description: descriptionText)
        
        appSyncClient?.perform(mutation: addEventMutation, optimisticUpdate: { transaction in
            do {
                // Update our normalized local store immediately for a responsive UI.
                try transaction?.update(query: ListEventsQuery()) { (data: inout ListEventsQuery.Data) in
                    let localItem = ListEventsQuery.Data.ListEvent.Item(id: temporaryLocalID,
                                                                        description: descriptionText,
                                                                        name: nameText,
                                                                        when: whenText,
                                                                        where: whereText,
                                                                        comments: nil)
                    
                    data.listEvents?.items?.append(localItem)
                }
            } catch {
                print("Error updating the cache with optimistic response: \(error)")
            }
        }) { (result, error) in
            defer {
                self.navigationController?.popViewController(animated: true)
                
                if let vc = self.navigationController?.viewControllers.last as? AWSCRUDAPIController {
                  //  vc.needUpdateList = true
                }
            }
            
            guard error == nil else {
                print("Error occurred posting a new item: \(error!.localizedDescription )")
                return
            }
            
            guard let createEventResponse = result?.data?.createEvent else {
                print("Result unexpectedly nil posting a new item")
                return
            }
            
            print("New item returned from server and stored in local cache, server-provided id: \(createEventResponse.id)")
            
            let newItem = ListEventsQuery.Data.ListEvent.Item(
                id: createEventResponse.id,
                description: createEventResponse.description,
                name: createEventResponse.name,
                when: createEventResponse.when,
                where: createEventResponse.where,
                // For simplicity, we're assuming newly-created events have no comments
                comments: nil
            )
            
            // Update the local cache for the "list events" operation
            _ = self.appSyncClient?.store?.withinReadWriteTransaction() { transaction in
                try transaction.update(query: ListEventsQuery()) { (data: inout ListEventsQuery.Data) in
                    guard data.listEvents != nil else {
                        print("Local cache unexpectedly has no results for ListEventsQuery")
                        return
                    }
                    
                    var updatedItems = data.listEvents?.items?.filter({ $0?.id != temporaryLocalID })
                    updatedItems?.append(newItem)
                    
                    // `data` is an inout variable inside a read/write transaction. Setting `items` here will cause the
                    // local cache to be updated
                    data.listEvents?.items = updatedItems
                }
            }
        }
    }
    
    @objc func cancleAction(sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}
