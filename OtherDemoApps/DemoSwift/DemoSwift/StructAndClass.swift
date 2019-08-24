//
//  StructAndClass.swift
//  DemoSwift
//
//  Created by huixiubao on 8/14/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import Foundation

struct Foo {

    var x = 2
}

class Bar {
    var x = 2
}

class Demo {
    func method() -> () {
        let f1 = Foo()
        var f2 = f1
        f2.x += 1
        
        print(f1.x)
        print(f2.x)
        
        let b1 = Bar()
        var b2 = b1
        b2.x += 1
        print(b1.x)
        print(b2.x)
    }
}

