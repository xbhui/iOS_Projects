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
    static var privateCloudDatabase: CKDatabase {
        return CKContainer.default().privateCloudDatabase
    }
    //MARK: Subscriptions
    static func saveSbuscriptions() {
        
        let subID = String(NSUUID().uuidString)
        let predicate = NSPredicate(value: true)   //no predicate conditions

        let rcsub = CKQuerySubscription(recordType: recordType, predicate: predicate, subscriptionID: subID, options: [.firesOnRecordCreation, .firesOnRecordUpdate, .firesOnRecordDeletion])
        
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "create, update, delete notification"
        notification.shouldBadge = true
        notification.soundName = "default"
        notification.shouldSendContentAvailable = true
        rcsub.notificationInfo = notification
        
        publicCloudDatabase.save(rcsub) { (subscription, error) in
            if error != nil {
                print("ping sub failed, almost certainly cause it is already there \(String(describing: error))")
            } else {
                print("bing subscription saved! \(subID) ")
            }
        }
        
        privateCloudDatabase.save(rcsub) { (subscription, error) in
            if error != nil {
                print("ping sub failed, almost certainly cause it is already there \(String(describing: error))")
            } else {
                print("bing subscription saved! \(subID) ")
            }
        }
        
        
     //   saveZoneSubcription()
    //  saveDatabaseSubcription()
    }
    
    static func saveZoneSubcription() -> () {
        let zone = CKRecordZone.init(zoneName: "c00000001")
        privateCloudDatabase.save(zone) { (zone, error) in
            if error != nil {
                print("zone save failed")
            } else {
                print("zone saved")
            }
        }
        
        let subzone = CKRecordZoneSubscription.init(zoneID: zone.zoneID)
        let notifzone = CKSubscription.NotificationInfo()
        notifzone.alertBody = "zone notification"
        notifzone.shouldBadge = true
        notifzone.soundName = "default"
        notifzone.shouldSendContentAvailable = true
        subzone.notificationInfo = notifzone
        
        privateCloudDatabase.save(subzone) { (sub, error) in
            if error != nil {
                print("zone subscription failed")
            } else {
                print("zone subscription saved")
            }
        }
    }
    
    static func saveDatabaseSubcription() -> () {
        let subdb = CKDatabaseSubscription.init(subscriptionID: CKSubscription.ID.init("db00001"))
        let notifdb = CKSubscription.NotificationInfo()
        notifdb.alertBody = "db notification"
        notifdb.shouldBadge = true
        notifdb.soundName = "default"
        notifdb.shouldSendContentAvailable = true
        subdb.notificationInfo = notifdb
        
        publicCloudDatabase.save(subdb) { (sub, error) in
            if error != nil {
                print("db subscription failed")
            } else {
                print("db subscription saved")
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
        
//        privateCloudDatabase.perform(query, inZoneWith: nil) { (records, error) in
//            let students = records?.map(Student.init)
//            DispatchQueue.main.async {
//                completion(students, error as NSError?)
//            }
//        }
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
        
        let privatezone = CKRecordZone.init(zoneID: CKRecordZone.ID.init(zoneName: "private00000001", ownerName: "__defaultOwner__"))
        let private_recordname = recordData["name"] as! String
        let private_record = CKRecord.init(recordType: recordType, recordID: CKRecord.ID.init(recordName: private_recordname, zoneID: privatezone.zoneID))

        for (key, value) in recordData {
            if key == spicture {
                if let path = Bundle.main.path(forResource: value, ofType: "jpg") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        private_record.setValue(data, forKey: key)
                    } catch let error {
                        print(error)
                    }
                }
            }else if key == sgrade {
                private_record.setValue(Double(value), forKey: key)
            } else {
                private_record.setValue(value, forKey: key)
            }
        }
        
    //save to private
        privateCloudDatabase.save(private_record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(private_record, error as NSError?)
            }
        }
        
        let public_recordname = recordData["name"] as! String
        let public_record = CKRecord.init(recordType: recordType, recordID: CKRecord.ID.init(recordName: public_recordname))
        
        for (key, value) in recordData {
            if key == spicture {
                if let path = Bundle.main.path(forResource: value, ofType: "jpg") {
                    do {
                        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                        public_record.setValue(data, forKey: key)
                    } catch let error {
                        print(error)
                    }
                }
            }else if key == sgrade {
                public_record.setValue(Double(value), forKey: key)
            } else {
                public_record.setValue(value, forKey: key)
            }
        }
        
        //save to private
        publicCloudDatabase.save(public_record) { (savedRecord, error) in
            DispatchQueue.main.async {
                completion(public_record, error as NSError?)
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
    
    //MARK: with conflict policy for updating the record by recordId
    static func saveForCoflictRevolustion(_ recordId: String, text: String, completion: @escaping (CKRecord?, NSError?) -> Void) {
        
        let recordIDToSave = CKRecord.ID(recordName: recordId)
        publicCloudDatabase.fetch(withRecordID: recordIDToSave) { (record, error) in
            
            if let recordToSave = record {
                //Modify the record value here
                recordToSave.setValue(text, forKey: stext)
           //     recordToSave.setObject("value" as __CKRecordObjCValue, forKey: "text")
                let modifyRecords = CKModifyRecordsOperation(recordsToSave:[recordToSave], recordIDsToDelete: nil)
                modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.allKeys
                //    modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.changedKeys
                //   modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.ifServerRecordUnchanged
                modifyRecords.qualityOfService = QualityOfService.userInitiated
                modifyRecords.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                    if error == nil {
                        print("Modified")
                    }else {
                        print(error as Any)
                    }
                }
                
                publicCloudDatabase.add(modifyRecords)
            }else{
                print(error.debugDescription)
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
        
        
        privateCloudDatabase.delete(withRecordID: recordId, completionHandler: { deletedRecordId, error in
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
