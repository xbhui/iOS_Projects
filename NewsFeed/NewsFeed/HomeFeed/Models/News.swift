//
//  News.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import CoreData

struct News {
    var title: String!
    var details: String!
    var date: Date!
    var status: Int64 = 0
    var newsLink: String!
    var image: Data!
}
