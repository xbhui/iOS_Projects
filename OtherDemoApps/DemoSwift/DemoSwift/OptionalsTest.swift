//
//  OptionalsTest.swift
//  DemoSwift
//
//  Created by huixiubao on 8/15/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import Foundation
class OptionalDemo {
    func method() {
        var a: String = "A"
        var b: String! = "B"
        var c: String? = "C"
   //     a = nil
        b = nil
        c = nil
        b = a
        a = b
//      a = c
        c = b
        b = c
        
        print(a)
        print(b)
        print(c)
    }
}
