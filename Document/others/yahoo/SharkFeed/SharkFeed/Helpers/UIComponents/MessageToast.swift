//
//  MessageToast.swift
//  SharkFeed
//
//  Created by gauss on 6/16/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import Foundation

class MessageToast {
    static func show(message: String, controller: UIViewController) {
        let toastContainer = createContainer()
        let toastLabel = createLabel(msg: message)
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        let toastconstant1 = NSLayoutConstraint(item: toastLabel, attribute: .leading,
                                    relatedBy: .equal, toItem: toastContainer, attribute: .leading,
                                    multiplier: 1, constant: 15)
        let toastconstant2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing,
                                    relatedBy: .equal, toItem: toastContainer, attribute: .trailing,
                                    multiplier: 1, constant: -15)
        let toastconstant3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom,
                                    relatedBy: .equal, toItem: toastContainer, attribute: .bottom,
                                    multiplier: 1, constant: -15)
        let toastconstant4 = NSLayoutConstraint(item: toastLabel, attribute: .top,
                                    relatedBy: .equal, toItem: toastContainer, attribute: .top,
                                    multiplier: 1, constant: 15)
        toastContainer.addConstraints([toastconstant1, toastconstant2, toastconstant3, toastconstant4])
        let controller1 = NSLayoutConstraint(item: toastContainer, attribute: .leading,
                                    relatedBy: .equal, toItem: controller.view, attribute: .leading,
                                    multiplier: 1, constant: 65)
        let controller2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing,
                                    relatedBy: .equal, toItem: controller.view, attribute: .trailing,
                                    multiplier: 1, constant: -65)
        let controller3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom,
                                    relatedBy: .equal, toItem: controller.view, attribute: .bottom,
                                    multiplier: 1, constant: -75)
        controller.view.addConstraints([controller1, controller2, controller3])
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    static func createLabel(msg: String) -> UILabel {
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font.withSize(12.0)
        toastLabel.text = msg
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        return toastLabel
    }
    static func createContainer() -> UIView {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 25
        toastContainer.clipsToBounds  =  true
        return toastContainer
    }
}
