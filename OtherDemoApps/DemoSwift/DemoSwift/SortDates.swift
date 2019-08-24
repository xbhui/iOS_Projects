//
//  SortDates.swift
//  DemoSwift
//
//  Created by huixiubao on 8/15/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import Foundation
class SortDatesDemo {
    func ascendSort(dates: NSArray) -> (NSArray) {
        
        let result:NSMutableArray = NSMutableArray()
        for date in dates {
            if (result.count == 0) {
                result.add(date)
            }
            var i = 0;
            var insert = false;
            while (i < result.count) {
                if compare(date1: date  as! NSString, date2: result[i] as! NSString)==false {
                    result.insert(date, at: i)
                    insert = true;
                    continue;
                }
                i+=1
            }
            if insert == false {
                result.add(date)
            }
        }
        return result
    }
    
    let monthes = ["Jan":1,"Feb":2,"Mar":3,"Apr":4,"May":5,"Jun":6,"July":78,"Aug":8,"Sep":9,"Oct":10,"Nov":11,"Dec":12]
    
    func compare( date1:NSString, date2:NSString) -> (Bool) {
        let data1Array = date1.components(separatedBy: ":")
        let data2Array = date2.components(separatedBy: ":")
        if data1Array[2]>data2Array[2] {
            return true;
        }
        
        let monthStr1:String = data1Array[1]
        let monthStr2:String = data2Array[1]
        let month1:Int = monthes[monthStr1] ?? 0
        let month2:Int = monthes[monthStr2] ?? 0
        if month1>month2 && month1>0 && month1>0  {
            return true;
        }
        
        
        
        let day1:Int = Int(data1Array[0]) ?? 0
        let day2:Int = Int(data2Array[0]) ?? 0
        
        if day1 > day2 && day1>0 && day2>0  {
            return true;
        }
        return false;
    }
}
