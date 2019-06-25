//
//  HttpDownloadManager.swift
//  SharkFeed
//
//  Created by gauss on 6/15/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HttpDownloadManager: NSObject {

    public static let sharedInstance = HttpDownloadManager()
    private override init() {
        super.init()
    }
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
    func downloadImageTask(urlStr: String, completionHandler: @escaping (UIImage, Error?) -> Void) {
        var task: URLSessionDownloadTask? = URLSessionDownloadTask()
        let session: URLSession? = URLSession.shared
        if let url = URL.init(string: urlStr as String) {
            task = session?.downloadTask(with: url, completionHandler: { (completionURL, response, error) -> Void in
                if let data = try? Data(contentsOf: completionURL!) {
                    let img: UIImage! = UIImage(data: data)
                    completionHandler(img, error)
                }
                print(response as Any)

            })
            task?.resume()
        }
    }
}
