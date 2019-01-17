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
        
        saveZoneSubcription()
        saveDatabaseSubcription()
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
        
//        privateCloudDatabase.save(subdb) { (sub, rror) in
//            if error != nil {
//                print("db subscription failed")
//            } else {
//                print("db subscription saved")
//            }
//        }
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
    
    
//    + (void)saveRecords:(NSArray *)records complete:(void(^)(NSArray *recordIDs, NSError *error))complete {
//
//    records = [records valueForKeyPath:@"record"];
//
//    CKModifyRecordsOperation *operation = [[CKModifyRecordsOperation alloc] initWithRecordsToSave:records recordIDsToDelete:nil];
//
//    operation.savePolicy = CKRecordSaveAllKeys;
//
//    [operation setModifyRecordsCompletionBlock:^(NSArray<CKRecord *> * _Nullable savedRecords, NSArray<CKRecordID *> * _Nullable deletedRecordIDs, NSError * _Nullable operationError) {
//    complete([savedRecords valueForKeyPath:@"recordID.recordName"], operationError);
//    }];
//
//    [[self dataBase] addOperation:operation];
//    }
    
    func pushRecordChangesForZoneID(recordZoneID: CKRecordZone.ID) {
        // ...
//        modifyRecordsOperation.modifyRecordsCompletionBlock = { (savedRecords, deletedRecordIDs, error) -> Void in
//            if (error != nil) {
//                if error.code == CKErrorCode.PartialFailure.rawValue {
//                    if let errorDict = error.userInfo?[CKPartialErrorsByItemIDKey] as? [CKRecordID : NSError] {
//                        for (recordID, partialError) in errorDict {
//                            if partialError.code == CKErrorCode.ServerRecordChanged.rawValue {
//                                if let userInfo = partialError.userInfo {
//                                    let serverRecord = userInfo[CKRecordChangedErrorServerRecordKey] as? CKRecord
//                                    // serverRecord will always be nil
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
    }
//    func getLatestServerChanges (_ completion: @escaping ((_ hasIncomingChanges: Bool) -> Void)) {
//
//        let changeToken = UserDefaults.standard.serverChangeToken
//
//        CKDBManager.publicCloudDatabase.queryUpdates(sinceDate: Date(timeIntervalSince1970: 0)) { changedTasks, deletedTasksIds, error in
//            for task in changedTasks {
////                self.localRepository.saveTask(task, completion: { (task) in
////                    print("saved to local db")
////                })
//            }
//            for remoteId in deletedTasksIds {
////                self.localRepository.deleteTask(objectId: remoteId, completion: { (success) in
////                    print(">>>>  deleted from local db: \(remoteId) \(success)")
////                })
//            }
//            completion(changedTasks.count > 0 || deletedTasksIds.count > 0)
//        }
//    }
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
    
    func save(parameters: String) ->  () {
        
        let recordIDToSave = CKRecord.ID(recordName: "recordID")
        let publicData = CKContainer.default().publicCloudDatabase
    
        publicData.fetch(withRecordID: recordIDToSave) { (record, error) in
        
            if let recordToSave = record {
        
                //Modify the record value here
                recordToSave.setObject("value" as __CKRecordObjCValue, forKey: "key")
            
                let modifyRecords = CKModifyRecordsOperation(recordsToSave:[recordToSave], recordIDsToDelete: nil)
                modifyRecords.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.allKeys
                modifyRecords.qualityOfService = QualityOfService.userInitiated
                modifyRecords.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
                        if error == nil {
                            print("Modified")
                        }else {
                            print(error as Any)
                        }
                    }
                
                publicData.add(modifyRecords)
            }else{
                print(error.debugDescription)
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
    
//    public extension UserDefaults {
//
//        var serverChangeToken: CKServerChangeToken? {
//            get {
//                guard let data = self.value(forKey: "ChangeToken") as? Data else {
//                    return nil
//                }
//                guard let token = NSKeyedUnarchiver.unarchiveObject(with: data) as? CKServerChangeToken else {
//                    return nil
//                }
//
//                return token
//            }
//            set {
//                if let token = newValue {
//                    let data = NSKeyedArchiver.archivedData(withRootObject: token)
//                    self.set(data, forKey: "ChangeToken")
//                    self.synchronize()
//                } else {
//                    self.removeObject(forKey: "ChangeToken")
//                }
//            }
//        }
//    }
//    1.3）刷新区更改令牌
//
//    您可以通过刷新区更改令牌：使用的NSKeyedArchiver执行 CKFetchRecordChangesOperation， fetchRecordChangesCompletionBlock回报CKServerChangeToken 保存到UserDefaults（例如）） 。此操作的任务是刷新令牌，并在结束同步过程中执行该令牌。
//    
//    我在私有云数据库中有自定义区域。 我使用OperationQueue来建立不同的依赖于彼此的异步过程。一些操作有自己的操作队列。
//    
//    步骤：
//    
//    1）检查我的自定义区域是存在
//    
//    1.1）如果没有自定义区域
//    
//    1.2）创建新的自定义区域。 （可选：添加记录）
//    
//    1.3）刷新区更改令牌
//    
//    您可以通过刷新区更改令牌：使用的NSKeyedArchiver执行 CKFetchRecordChangesOperation， fetchRecordChangesCompletionBlock回报CKServerChangeToken 保存到UserDefaults（例如）） 。此操作的任务是刷新令牌，并在结束同步过程中执行该令牌。
//    
//    2）如果已经有自定义区域
//    
//    2.1）获取使用以前保存区更改令牌从区域变化。 （CKFetchRecordChangesOperation）
//    
//    2.2）更新和删除本地记录。
//    
//    2.3）刷新区域更改标记。
//    
//    2.4）检查本地更改（我使用最后一个云同步时间戳来检查后面修改了哪些记录）。
//    
//    2.5）将记录上传到云工具包数据库
//    
//    2.6）再次刷新区域更改标记。
}
