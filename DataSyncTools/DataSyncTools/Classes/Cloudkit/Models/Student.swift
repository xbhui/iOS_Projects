//
//  Student.swift
//  DataSyncTools
//
//  Created by gauss on 1/10/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import CloudKit

private let kStudentsSourcePlist = "Students"

let sname = "name"
let stext = "text"
let spicture = "image"
let sgrade = "avggrade"

class Student: Equatable {
    
    static var students: [[String: String]]!
    
    var name: String
    var text: String
    var image: UIImage?
    var avggrade: String
    var identifier: String
    
    init(record: CKRecord) {
        self.name = record.value(forKey: sname) as! String
        self.text = record.value(forKey: stext) as! String
        if let imageData = record.value(forKey: spicture) as? Data {
            self.image = UIImage(data:imageData)
        }
        let avg = record.value(forKey: sgrade) ?? 0.0
        self.avggrade = "\(avg)"
        self.identifier = record.recordID.recordName
    }
    
    static func ==(lhs: Student, rhs: Student) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}


extension Student {
    static var defaultContent: [[String: String]] {
        if students == nil {
            let path = Bundle.main.path(forResource: kStudentsSourcePlist, ofType: "plist")
            let plistData = try? Data(contentsOf: URL(fileURLWithPath: path!))
            assert(plistData != nil, "Source doesn't exist")
            
            do {
                students = try PropertyListSerialization.propertyList(from: plistData!,
                                                                    options: .mutableContainersAndLeaves, format: nil) as! [[String: String]]
            }
            catch _ {
                print("Cannot read data from the plist")
            }
        }
        
        return students
    }
}
