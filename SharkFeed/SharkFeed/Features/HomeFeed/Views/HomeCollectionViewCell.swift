//
//  HomeCollectionViewCell.swift
//  SharkFeed
//
//  Created by gauss on 6/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    static let identifer = "kHomeCollectionViewCell"
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setupViews()
    }
    func setupViews() {
        let defaultImg = UIImage.init(named: imgHomesharkdefault)
        let imgView = UIImageView.init(frame: CGRect(x: 0, y: 0,
                                                     width: self.frame.size.width, height: self.frame.size.height))
        imgView.image = defaultImg
        self.backgroundView = imgView
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
