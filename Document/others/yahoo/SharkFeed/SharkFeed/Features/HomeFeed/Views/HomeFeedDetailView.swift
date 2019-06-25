//
//  HomeFeedDetailView.swift
//  SharkFeed
//
//  Created by gauss on 6/15/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

public protocol HomeFeedDetailViewActionDelegate: class {
    func handleSaveImageAction()
    func handleOpenFlickrPage()
    func handlePhotoPinchAction(pinGesture: UIPinchGestureRecognizer)
}

class HomeFeedDetailView: UIView {
    static let identifer = "kHomeFeedDetailView"

    var photoDisplay: UIImageView!
    var titleDisplay: UILabel!
    var descriptionDisplay: UILabel!
    var line: CAShapeLayer!
    var btnLeft: UIButton!
    var labLeft: UILabel!
    var btnRight: UIButton!
    var labRight: UILabel!
    weak var delegate: HomeFeedDetailViewActionDelegate!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        photoDisplay = UIImageView.init(frame: self.bounds)
        self.addSubview(photoDisplay)
        createToolbar()
    }
    func createToolbar() {
        btnLeft = UIButton(type: .custom)
        btnLeft.setBackgroundImage(UIImage(named: imgDetailDownload), for: .normal)
        btnLeft.addTarget(self, action: #selector(handleSaveImage), for: .touchUpInside)
        btnLeft.frame = CGRect(x: 10, y: self.bounds.height-20-25, width: 25, height: 29)

        self.addSubview(btnLeft)
        labLeft = UILabel.init(frame: CGRect(x: btnLeft.frame.origin.x + btnLeft.frame.size.width+10,
                                                 y: self.bounds.height-20-25, width: 120, height: 29))
        labLeft.text = downloadTitle
        labLeft.backgroundColor = .clear
        labLeft.textColor = .white
        labLeft.font = .systemFont(ofSize: 15)
        self.addSubview(labLeft)
        btnRight = UIButton(type: .custom)
        btnRight.autoresizingMask = [.flexibleWidth, .flexibleRightMargin, .flexibleBottomMargin]

        btnRight.setBackgroundImage(UIImage(named: imgOpenInFlickr), for: .normal)
        btnRight.addTarget(self, action: #selector(handleOpenFlickrPage), for: .touchUpInside)
        self.addSubview(btnRight)
        labRight = UILabel.init(frame: CGRect(x: btnRight.frame.origin.x + btnRight.frame.size.width + 10,
                                                  y: self.bounds.height-20-26, width: 120, height: 26))
        labRight.text = openInAppTitle
        labRight.textColor = .white
        labRight.backgroundColor = .clear
        labRight.font = .systemFont(ofSize: 15)
        self.addSubview(labRight)
        self.drawWhiteLine()
    }
    func drawWhiteLine() {
        if line != nil {
            line.removeFromSuperlayer()
            line = nil
        }
        line = CAShapeLayer()
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: 10, y: self.bounds.height-20-25-20))
        linePath.addLine(to: CGPoint(x: self.bounds.width-10, y: self.bounds.height-20-25-20))
        line.path = linePath.cgPath
        line.strokeColor = UIColor.white.cgColor
        line.lineWidth = 1.0
        line.lineJoin = .round
        self.layer.addSublayer(line)
    }
    func updateView(image: UIImage) {
        self.photoDisplay.autoresizingMask = [.flexibleWidth, .flexibleHeight,
                                              .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.photoDisplay.frame = self.bounds
        self.photoDisplay.image = image
        self.addPinGestureForPhoto()
    }
    func addPinGestureForPhoto() {
        self.photoDisplay.isUserInteractionEnabled = true
        let gesture = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePhotoPinch(gesture:)))
        self.photoDisplay.addGestureRecognizer(gesture)
    }
    func addSwipeGestureForView() {
        self.photoDisplay.isUserInteractionEnabled = true
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handlePhotoPinch(gesture:)))
        swipeRight.direction = .right
        self.photoDisplay.addGestureRecognizer(swipeRight)
    }
    @objc func handleSaveImage() {
        self.delegate.handleSaveImageAction()
    }
    @objc func handleOpenFlickrPage() {
        self.delegate.handleOpenFlickrPage()
    }
    @objc func handlePhotoPinch(gesture: UIPinchGestureRecognizer) {
        self.delegate.handlePhotoPinchAction(pinGesture: gesture)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if labRight != nil {
            btnLeft.frame = CGRect(x: 10, y: self.bounds.height-20-25, width: 25, height: 29)
            labLeft.frame = CGRect(x: btnLeft.frame.origin.x + btnLeft.frame.size.width+10,
                                   y: self.bounds.height-20-25, width: 120, height: 29)
            btnRight.frame = CGRect(x: self.bounds.width/2+10, y: self.bounds.height-20-25, width: 27, height: 26)
            labRight.frame = CGRect(x: btnRight.frame.origin.x + btnRight.frame.size.width + 10,
                                    y: self.bounds.height-20-26, width: 120, height: 26)
            self.drawWhiteLine()
        }
    }
}
