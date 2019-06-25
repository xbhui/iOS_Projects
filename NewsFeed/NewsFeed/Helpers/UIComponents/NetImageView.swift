//
//  NetImage.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

extension UIImageView {
    func imageWithUrl(url: String)  {
        // if local has this image, load from local
    
        // if local doesn't has, load default picture, then download from net work
        self.image = UIImage.init(named: "")
        DispatchQueue.global().async {
            if let imageUrl = URL.init(string: url) {
                do {
                    let imageData = try Data(contentsOf: imageUrl)
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                        self.image = image
                    })
                } catch {
                    print("error")
                }
            }
        }

    }
}
