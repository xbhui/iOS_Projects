//
//  APIManager.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

protocol APIManagerDelegate {
    func parsingDidSucceed(result: [News])
    func parsingDidFail(error: NSError)
}

final class APIManager: NSObject, XMLParserDelegate {
  
    public static let shared = APIManager()
    public var delegate: APIManagerDelegate?

    private var parser: XMLParser?
    private var newsItems: [News] = []
    private var currentElementName: String = String()
    private var currentItem: News!

    var title = String()
    var details = String()
    var date = String()
    var newsLink = String()
    var imageUrl = String()
    
    // Mark - XML for Home page
    func XMLBeginParsing() {
        parser = XMLParser(contentsOf: URL.init(string: newsFeedURLString)!)!
        parser!.delegate = self
        parser!.parse()
    }
    
    // MARK - XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElementName = elementName
        if elementName == "item" {
            title = String()
            details = String()
            date = String()
            newsLink = String()
            imageUrl = String()
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if !data.isEmpty {
            switch currentElementName {
                case "title":
                    title += data
                case "description":
                    details += data
                case "pubDate":
                    date += data
                case "link":
                    newsLink += data
                case "image":
                    imageUrl += data
                default:
                    break
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            var item = News()
            item.title = title
            item.details = details
            item.date = DateFormateUtility.shared.dateFromString(string: date) as Date?
            item.newsLink = newsLink
            item.image = WebImage.share.imageFromUrl(imageUrl: imageUrl)
            newsItems.append(item)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        delegate?.parsingDidSucceed(result: newsItems)
    }
}
