//
//  NavbarTitleLabel.swift
//  SharkFeed
//
//  Created by gauss on 6/16/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class NavbarTitleLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    func setup(title: String) {
        self.text = title
        self.textColor = .white
        self.font = .systemFont(ofSize: 20)
        self.textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
