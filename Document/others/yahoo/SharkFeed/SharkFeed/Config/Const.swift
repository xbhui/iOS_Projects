//
//  Const.swift
//  SharkFeed
//
//  Created by gauss on 6/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import Foundation

    // MARK: Image name define
let imgHomeNavbar = "navbarimg.png"
let imgHomesharkdefault = "defaultshark.png"
let imgDetailDownload = "Download.png"
let imgDetailFlickr = "Flickr-icon.png"
let imgOpenInFlickr = "Open_in_flickr.png"
let imgPullToRefresh1 = "Pull to refresh 1.png"
let imgPullToRefresh2 = "Pull to refresh 2.png"
let imgSharkFeedLogo = "SharkFeed Logo.png"
let imgSharkFeedSmall = "SharkFeed_logosmall.png"
let imgSharkFeed = "SharkFeed.png"
let imgSwipeToFeed = "Swipe_to_feed.png"

// MARK: - frame
let kScreenWitdh = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

// MARK: - Device info
let getAppInfo = Bundle.main.infoDictionary
let getSystemVersion = UIDevice.version()

// MARK: - download info
let numFirstPage: Int = 1

// MARK: String
let refreshHeaderPullRefresh = "Pull refresh sharks"
let toastMessageSuccess = "save success!"
let toastMessageFailed = "save failed!"
let downloadTitle = "Download"
let openInAppTitle = "Open in App"
