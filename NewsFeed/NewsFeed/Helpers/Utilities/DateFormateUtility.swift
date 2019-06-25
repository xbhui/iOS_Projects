//
//  DateFormateUtility.swift
//  NewsFeed
//
//  Created by gauss on 6/23/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class DateFormateUtility: NSObject {
    private let PubDateDateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
    static let shared = DateFormateUtility()
    private let dateFormatter: DateFormatter
    
    override init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = PubDateDateFormat
        super.init()
    }
    
    func dateFromString(string: String) -> NSDate? {
        return dateFormatter.date(from: string) as NSDate?
    }
    
    func stringFromDate(date: NSDate) -> String {
        return dateFormatter.string(from: date as Date)
    }
}
