//
//  HttpDownloadManger.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HttpDownloadManager: NSObject, XMLParserDelegate {
    public static let sharedInstance = HttpDownloadManager()
    
    private override init() {
        super.init()
    }
    
    // Mark - JSON
    func getSessionDataTask(url: String, completionHandler: @escaping (NSDictionary, Error?) -> Void) {
        let sess = URLSession.shared
        let urls: NSURL = NSURL.init(string: url)!
        let request: URLRequest = NSURLRequest.init(url: urls as URL) as URLRequest
        let task = sess.dataTask(with: request) { (data, res, error) in
            if error == nil {
                do {
                    guard let dict = try JSONSerialization.jsonObject(with: data!,
                                                                      options: JSONSerialization.ReadingOptions.allowFragments)
                        as? NSDictionary else { return }
                    completionHandler(dict, error)
                } catch {
                    print("GetSessionDataTask Exception")
                }
            }
            print(res as Any)
        }
        task.resume()
    }
    // Mark - XML
}

