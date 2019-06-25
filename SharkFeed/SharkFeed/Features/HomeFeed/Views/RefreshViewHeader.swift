//
//  RefreshViewHeader.swift
//  SharkFeed
//
//  Created by gauss on 6/16/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class RefreshViewHeader: UIRefreshControl {
    static let identifer = "kRefreshViewHeader"

    var refreshIcon1: UIImageView!
    var refreshIcon2: UIImageView!
    var textLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.autoresizesSubviews = true
        self.setUpViews()
    }
    func setUpViews() {
        self.refreshIcon1 = UIImageView.init(frame:
            CGRect(x: self.bounds.size.width/2 - 11, y: 20, width: 22, height: 31))
        self.refreshIcon1.image = UIImage.init(named: imgPullToRefresh1)
        self.addSubview(self.refreshIcon1)
        self.refreshIcon2 = UIImageView.init(frame:
            CGRect(x: self.bounds.size.width/2 - 11, y: 50, width: 28, height: 44))
        self.refreshIcon2.image = UIImage.init(named: imgPullToRefresh2)
        self.addSubview(self.refreshIcon2)
        self.textLabel = UILabel.init(frame:
            CGRect(x: self.bounds.size.width/2 - 100, y: 98, width: 200, height: 44))
        self.textLabel.text = refreshHeaderPullRefresh
        self.textLabel.textColor = .black
        self.textLabel.textAlignment = .center
        self.textLabel.font = .systemFont(ofSize: 15)
        self.textLabel.backgroundColor = .clear
        self.addSubview(self.textLabel)
    }
    func resetViewFrame() {
        self.refreshIcon1.frame = CGRect(x: self.bounds.size.width/2 - 11,
                                         y: 20, width: 22, height: 31)
        self.refreshIcon2.frame = CGRect(x: self.bounds.size.width/2 - 11,
                                         y: 50, width: 28, height: 44)
        self.textLabel.frame = CGRect(x: self.bounds.size.width/2 - 100,
                                      y: 98, width: 200, height: 44)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.resetViewFrame()
    }
}
