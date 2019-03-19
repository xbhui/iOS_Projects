//
//  CommentCell.swift
//  DataSyncTools
//
//  Created by gauss on 2/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    var commentContent: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commentContent = UILabel(frame: CGRect(x: 20, y: 0, width:  UIScreen.main.bounds.width, height: 40))
        commentContent.textColor = UIColor.black
        commentContent.font = UIFont.systemFont(ofSize: 15)
        commentContent.textAlignment = .left
        
        contentView.addSubview(commentContent)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
