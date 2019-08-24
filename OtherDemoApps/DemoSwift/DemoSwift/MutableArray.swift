//
//  main.swift
//  DemoSwift
//
//  Created by huixiubao on 8/15/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import Foundation


class MutableArray {
    

    let arr1 = [-5, -3, 0, 7, 11]
    let arr2 = [-1,0,7]

    func Test() {
        let ret: NSArray = self.mergeTwoSortedArray(array1: arr1 as NSArray, array2: arr2 as NSArray)
    }
    
    func mergeTwoSortedArray(array1: NSArray, array2: NSArray)->(NSArray) {

        let result:NSMutableArray = NSMutableArray()

        var idx1:Int = 0
        var idx2:Int = 0

        while idx1 < array1.count && idx2 < array2.count {
            let num1:Int = array1[idx1] as! Int
            let num2:Int = array2[idx2] as! Int
            
            if num1 > num2 {
                result.add(num1)
                idx1+=1
            }else if num1 < num2  {
                result.add(num2)
                idx2+=1
            }else if num1 == num2  {
                result.add(num1)
                result.add(num2)
                idx1+=1
                idx2+=1
            }
        }
        
        while idx1 < array1.count {
            result.add(array1[idx1])
            idx1+=1
        }
        
        while idx2 < array2.count {
            result.add(array2[idx2])
            idx2+=1
        }
        
        return result as NSArray
    }
}
