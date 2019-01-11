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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        iView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150))
        iView.layer.masksToBounds = true
        nlabel = UILabel(frame: CGRect(x: 0, y: iView.frame.size.height, width:  UIScreen.main.bounds.width-20, height: 30))
        nlabel.textColor = UIColor.black
        nlabel.font = UIFont.boldSystemFont(ofSize: 30)
        nlabel.textAlignment = .right

        contentView.addSubview(iView)
        contentView.addSubview(nlabel)
    }
    
    func setStudent(_ student: Student) {
        
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
