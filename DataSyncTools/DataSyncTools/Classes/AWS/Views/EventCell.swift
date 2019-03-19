//
//  EventCell.swift
//  DataSyncTools
//
//  Created by gauss on 2/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    private var eventlabel: UILabel!
    private var whenlabel: UILabel!
    private var wherelabel: UILabel!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        eventlabel = UILabel(frame: CGRect(x: 20, y: 0, width:  UIScreen.main.bounds.width, height: 40))
        eventlabel.textColor = UIColor.black
        eventlabel.font = UIFont.boldSystemFont(ofSize: 30)
        eventlabel.textAlignment = .left
        
        wherelabel = UILabel(frame: CGRect(x: 20, y: eventlabel.frame.size.height, width:  150, height: 30))
        wherelabel.textColor = UIColor.black
        wherelabel.font = UIFont.systemFont(ofSize: 20)
        wherelabel.textAlignment = .left
        
        whenlabel = UILabel(frame: CGRect(x: UIScreen.main.bounds.width-150-20, y: eventlabel.frame.size.height, width:  150, height: 30))
        whenlabel.textColor = UIColor.black
        whenlabel.font = UIFont.systemFont(ofSize: 20)
        whenlabel.textAlignment = .right
        
        
        contentView.addSubview(eventlabel)
        contentView.addSubview(whenlabel)
        contentView.addSubview(wherelabel)
    }
    
    
    func updateEvent(eventName: String?, when: String?, where: String?) {
        eventlabel.text = eventName
        whenlabel.text = when
        wherelabel.text = `where`
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
