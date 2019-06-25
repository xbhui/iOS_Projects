//
//  Constants.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import Foundation

struct Constants {
    struct cellIdentifier {
        public static let identifier: String = "HomeFeedTableViewCellId"
    }
    
    struct seguedentifier {
        public static let identifier: String = "feedDetailsWebView"
    }
    
    struct ErrorDescription {
        public static let fetchFeedFailed: String = "[CoreDataManager] fetch feed item failed!"
        public static let updateReadStatusFailed: String = "[CoreDataManager] update read status failed!"
        public static let saveItemFailed: String = "[CoreDataManager] Primary Key duplicate!"
    }
}
