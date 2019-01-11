//
//  APIViewController.swift
//  DataSyncTools
//
//  Created by gauss on 1/9/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class APIViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
