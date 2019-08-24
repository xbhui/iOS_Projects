//
//  RetainCycle.swift
//  DemoSwift
//
//  Created by huixiubao on 8/14/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

class Test {
    func someFunction() {
        weak var weakSelf = self
//        asynchNetworkRequest {result in
//            weakSelf?.updateUIWithResult(result)
//        }
    }
    func updateUIWithResult(_ result: Any) {
        // ...
    }
}

//func asynchNetworkRequest(completion:@escaping (_ result: Any)) -> void) {
//    // ...
//}
