//
//  CKDBManager.swift
//  DataSyncTools
//
//  Created by gauss on 1/9/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import CloudKit

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
    
    //MARK: add a new record
    static func createRecord(_ recordData: [String: String], completion: @escaping (_ record: CKRecord?, _ error: NSError?) -> Void) {
        let record = CKRecord(recordType: recordType)
        
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
