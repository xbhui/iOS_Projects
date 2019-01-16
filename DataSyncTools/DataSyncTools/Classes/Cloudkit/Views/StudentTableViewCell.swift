//
//  StudentTableViewCell.swift
//  DataSyncTools
//
//  Created by gauss on 1/10/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell {

    private var iView: UIImageView!
    private var nlabel: UILabel!
    private var glabel: UILabel!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        iView.layer.masksToBounds = true
   
        glabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-80-20, y: iView.frame.size.height, width:  80, height: 30))
        glabel.textColor = UIColor.black
        glabel.font = UIFont.boldSystemFont(ofSize: 30)
        glabel.textAlignment = .right
        
        nlabel = UILabel(frame: CGRect(x: 20, y: iView.frame.size.height, width:  200, height: 30))
        nlabel.textColor = UIColor.black
        nlabel.font = UIFont.boldSystemFont(ofSize: 30)
        nlabel.textAlignment = .left

        contentView.addSubview(iView)
        contentView.addSubview(nlabel)
        contentView.addSubview(glabel)
    }
    
    func setStudent(_ student: Student) {
        
        glabel.text = student.avggrade
        nlabel.text = student.name
        iView.alpha = 0.0
        iView.image = student.image
        
        UIView.animate(withDuration: 0.3) {
            self.iView.alpha = 1.0
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
