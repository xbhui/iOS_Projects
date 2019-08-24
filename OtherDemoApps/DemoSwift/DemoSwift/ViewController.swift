//
//  ViewController.swift
//  DemoSwift
//
//  Created by huixiubao on 8/7/19.
//  Copyright © 2019 huixiubao. All rights reserved.
//

import UIKit

struct DummyStack {
    var items = [Int]()
    func add(x: Int) {
        //items.append(x)
        print("hello world")
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let demo = Demo()
        demo.method();
        
        let dic = DictionaryTest()
        dic.method();
        
        let opt = OptionalDemo()
        opt.method();
     
        // Do any additional setup after loading the view.
    }


}

