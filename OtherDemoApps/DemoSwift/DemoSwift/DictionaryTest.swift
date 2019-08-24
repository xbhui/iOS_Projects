//
//  DictionaryTest.swift
//  DemoSwift
//
//  Created by huixiubao on 8/14/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import Foundation

enum Foo1: String {
   // typealias RawValue = String
    
    case one, two = "1"
    case three = "3"
    case fou = "4"
    
//    func four(value: Int) -> String {
//        return "Value is \(value)"
//    }
    
//    case four(value: Int) {
//
//    }
}

class DictionaryTest {
    func method1()->() {
       // let f: Foo = Foo1.fou.four(value: 23)
    }
    
    func method()->() {
        let names = ["Fruits":"Apple",
                     "Vegetable":"Carrot"]
        let food = names["Meat"] ?? "No found"
        print(food)
    }
}
