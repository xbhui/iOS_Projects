//
//  WebImage.swift
//  NewsFeed
//
//  Created by gauss on 6/24/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class WebImage: NSObject {
    public static let share = WebImage()
    func imageFromUrl(imageUrl: String) -> Data {
        if imageUrl == "" { return Data() }
        do {
            let urlStr = URL(string: imageUrl)
            return try Data(contentsOf: urlStr!)
        }catch {
            print("get data error")
        }
        return Data()
    }
}
