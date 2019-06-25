//
//  HomeFeedTableViewCell.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HomeFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var details: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var mark: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        date.text = nil
        details.text = nil
        title.text = nil
        picture.image = nil
        mark.text = nil
    }
    
    func configurateTheCell(_ item: News) {
        details.text = item.details
        title.text = item.title
        mark.text = item.status == 0 ?"unread" : "read"
        
        if item.image != nil {
            picture.image = UIImage(data: item.image)
        }
        
        if item.date != nil {
            date.text = DateFormateUtility.shared.stringFromDate(date: item.date! as NSDate )
        }
    }
}
