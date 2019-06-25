//
//  HomeFeedViewFlowLayout.swift
//  SharkFeed
//
//  Created by gauss on 6/16/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HomeFeedViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        self.itemSize = CGSize(width: 110, height: 110)
        self.minimumLineSpacing = 10
        self.minimumInteritemSpacing = 10
        self.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 10)
        self.footerReferenceSize = CGSize(width: 0, height: 0)
        self.scrollDirection = UICollectionView.ScrollDirection.vertical
        self.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
}
