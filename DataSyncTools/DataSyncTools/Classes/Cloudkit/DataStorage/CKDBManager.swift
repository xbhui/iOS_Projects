//
//  CKDBManager.swift
//  DataSyncTools
//
//  Created by gauss on 1/9/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class CKDBManager: NSObject {
    
    let databaseFileName = "ckdatabase.sqlite"
    var database:FMDatabase!
    var pathToDatabase: String!
    
    override init() {
        super.init()
        
        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
    }
    
    func createDatabase()->Bool {
        var created = false
        if FileManager.default.fileExists(atPath: pathToDatabase) {
                database = FMDatabase(path: pathToDatabase)
            if database != nil {
                if database.open() {
                    let createTableQuery = "";
                    do {
                        try database.executeUpdate(createTableQuery, values: nil)
                        created = true
                    }catch {
                        print("Could not create table: %s", error.localizedDescription)
                    }
                    database.close()
                }else {
                    print("Could not open the database: %d", databaseFileName)
                }
            }
        }
        
        return created
    }
  
    //translate object to sqlite for storage
    
//    func insert(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
//
//    func loadAllbyTable() -> <#return type#> {
//        <#function body#>
//    }
//
//    func deleteById(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
    
}
