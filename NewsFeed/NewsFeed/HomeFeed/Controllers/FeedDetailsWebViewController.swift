//
//  FeedDetailsWebViewController.swift
//  NewsFeed
//
//  Created by gauss on 6/23/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import WebKit

class FeedDetailsWebViewController: UIViewController, UIGestureRecognizerDelegate {
    @IBOutlet weak var webView: WKWebView!
    var newsLink: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.loadWebView()
    }
}

extension FeedDetailsWebViewController {
    func setupUI() {
        self.view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FeedDetailsWebViewController {
    func loadWebView() {
        let url: URL = URL(string: newsLink)!
        let request = URLRequest.init(url: url)
        self.webView.load(request)
    }
}
