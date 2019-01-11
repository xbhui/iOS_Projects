//
//  RMDataSyncController.swift
//  DataSyncTools
//
//  Created by gauss on 1/7/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class RMDataSyncController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.yellow
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
