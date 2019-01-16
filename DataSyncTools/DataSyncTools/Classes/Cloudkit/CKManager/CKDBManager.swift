//
//  CKDBManager.swift
//  DataSyncTools
//
//  Created by gauss on 1/9/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import CloudKit
import UserNotifications

public enum PredicateType : Int {
    case pall = 1
    case pname
    case pgrade
    case sort
}

public enum DatabaseType : Int {
    case dbprivate = 1
    case dbpublic
    case dbshared
}

private let recordType = "Student"

class CKDBManager: NSObject {
    
    fileprivate override init() {
        ///forbide to create instance of helper class
    }
    
    static var publicCloudDatabase: CKDatabase {
        return CKContainer.default().publicCloudDatabase
    }
    //MARK: Subscriptions
    static func saveSbuscriptions() {
        
        let subID = String(NSUUID().uuidString)
        let predicate = NSPredicate(value: true)   //no predicate conditions

        let subscription = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subID, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "create, update, delete notification"
        notification.shouldBadge = true
        notification.soundName = "default"
        notification.shouldSendContentAvailable = true
        subscription.notificationInfo = notification
        publicCloudDatabase.save(subscription) { (subscription, error) in
            if error != nil {
                print("ping sub failed, almost certainly cause it is already there \(String(describing: error))")
            } else {
                print("bing subscription saved! \(subID) ")
            }
        }
    }
    
    //MARK: Retrieve existing records
    static func fetchAllStudents(_ completion: @escaping (_ records: [Student]?, _ error: NSError?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        publicCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
            let students = records?.map(Student.init)
            DispatchQueue.main.async {
                completion(students, error as NSError?)
            }
        }
    }
    
    //MARK: Query with predicate
    static func performQuery(_ predType: PredicateType, completion: @escaping (_ records: [Student]?, _ error: NSError?) -> Void){

        var predicate = NSPredicate(value: true)

        if(predType == PredicateType.pname) {
             predicate = NSPredicate(format: "name =='Sam'")
        }else if (predType == PredicateType.pgrade) {
             predicate = NSPredicate(format: "avggrade > 90")
        }
        
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let sort = NSSortDescriptor(key: "avggrade", ascending: true)
        if (predType == PredicateType.sort) {
            query.sortDescriptors = [sort]
        }
        let operation = CKQueryOperation(query: query)
        var records =  [CKRecord]()
        operation.recordFetchedBlock = { (record : CKRecord?) in
            guard record != nil else {
                return
            }
            records.append(record!)
        }
    
        operation.queryCompletionBlock = { (cursor, error) in
            guard error == nil else {
                print(error?.localizedDescription ?? "Error")
                return
            }
            
            DispatchQueue.main.async {
                let students = records.map(Student.init)
                completion(students, error as NSError?)
            }
        }
        publicCloudDatabase.add(operation)
    }
    
    
    //MARK: add a new record
    static func createRecord(_ recordData: [String: String], completion: @escaping (_ record: CKRecord?, _ error: NSError?) -> Void) {
        
        let recordname = recordData["name"] as! String
        let record = CKRecord.init(recordType: recordType, recordID: CKRecord.ID.init(recordName: recordname))
        
        for (key, value) in recordData {
            if key == spicture {
                if let path = Bundle.main.path(forResource: value, ofType: "jpg") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        record.setValue(data, forKey: key)
                    } catch let error {
                        print(error)
                    }
                }
            }else if key == sgrade {
                record.setValue(Double(value), forKey: key)
            } else {
                record.setValue(value, forKey: key)
            }
        }
        
        publicCloudDatabase.save(record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(record, error as NSError?)
            }
        }
    }
    
    //MARK: updating the record by recordId
    static func updateRecord(_ recordId: String, text: String, completion: @escaping (CKRecord?, NSError?) -> Void) {
       // CKRecord.ID
        let recordId = CKRecord.ID(recordName: recordId)
        publicCloudDatabase.fetch(withRecordID: recordId) { updatedRecord, error in
            guard let record = updatedRecord else {
                DispatchQueue.main.async {
                    completion(nil, error as NSError?)
                }
                return
            }
            
            record.setValue(text, forKey: stext)
            self.publicCloudDatabase.save(record) { savedRecord, error in
                DispatchQueue.main.async {
                    completion(savedRecord, error as NSError?)
                }
            }
        }
    }
    
    //MARK: remove the record
    static func removeRecord(_ recordId: String, completion: @escaping (String?, NSError?) -> Void) {
        let recordId = CKRecord.ID(recordName: recordId)
        publicCloudDatabase.delete(withRecordID: recordId, completionHandler: { deletedRecordId, error in
            DispatchQueue.main.async {
                completion (deletedRecordId?.recordName, error as NSError?)
            }
        })
    }
    
    //MARK: check that user is logged
    static func checkLoginStatus(_ handler: @escaping (_ islogged: Bool) -> Void) {
        CKContainer.default().accountStatus{ accountStatus, error in
            if let error = error {
                print(error.localizedDescription)
            }
            switch accountStatus {
            case .available:
                handler(true)
            default:
                handler(false)
            }
        }
    }

    func getDatabase(type : DatabaseType ) -> (CKDatabase) {
        let container = CKContainer.default();
        if (type == DatabaseType.dbprivate) {
            return container.privateCloudDatabase;
        }else if (type == DatabaseType.dbpublic) {
            return container.publicCloudDatabase;
        }
        return container.sharedCloudDatabase;
    }
}
