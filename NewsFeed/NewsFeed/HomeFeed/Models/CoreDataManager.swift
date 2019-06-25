//
//  CoreDataManager.swift
//  NewsFeed
//
//  Created by gauss on 6/22/19.
//  Copyright © 2019 xiubao. All rights reserved.
//
import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
    
    // write items into core data
    public func writeNewsItem(newsList: [News], completionHandler: @escaping (NSArray, Error?) -> Void) {
        for item in newsList {
            let coreItem = NSEntityDescription.insertNewObject(forEntityName: "NewsItem", into: context) as! NewsItem
            coreItem.title = item.title
            coreItem.newsLink = item.newsLink
            coreItem.details = item.details
            coreItem.date = item.date
            coreItem.status = item.status
            coreItem.image = item.image
            saveContext()
        }
        completionHandler(newsList as NSArray, nil)
    }
    
    // fetch all the data
    public func fetchNewsItemList(completionHandler: @escaping ([News], Error?) -> Void) {
        var newsList = [News]()
        let fetchRequest: NSFetchRequest = NewsItem.fetchRequest()
   
        let sort = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let result = try context.fetch(fetchRequest)
            for entity in result {
                newsList.append(coreItemToItem(coreItem: entity))
            }
            completionHandler(newsList, nil)
        } catch let error  {
            print(error.localizedDescription)
            completionHandler(newsList, error)
        }
    }
    
    // update item by newslink(primary key)
    public func updateNewsItem(newsLink: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let fetchRequest: NSFetchRequest = NewsItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "newsLink==%@", newsLink)
        do {
            let result = try context.fetch(fetchRequest)
            for entity in result {
                entity.status = 1
            }
            completionHandler(true, nil)
        } catch let error {
            print(error.localizedDescription)
            completionHandler(false, error)
        }
        saveContext()
    }
    
    // select item by title
    public func getNewsItem(title: String, completionHandler: @escaping ([News], Error?) -> Void) {
         var newsList = [News]()
        let fetchRequest: NSFetchRequest = NewsItem.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title LIKE %@", String("*\(title)*"))
        do {
            let result = try context.fetch(fetchRequest)
            for entity in result {
                newsList.append(coreItemToItem(coreItem: entity))
            }
            completionHandler(newsList, nil)
        } catch let error {
            print(error.localizedDescription)
            completionHandler(newsList, error)
        }
    }
    
    // delete item by newsLink(primary key)
    public func deleteNewsItem(newsLink: String, completionHandler: @escaping (Bool, Error?) -> Void) {
        let deleteRequest: NSFetchRequest = NewsItem.fetchRequest()
        deleteRequest.predicate = NSPredicate(format: "newsLink==%@", newsLink)
        do {
            let result = try context.fetch(deleteRequest)
            for entity in result {
                context.delete(entity)
            }
            saveContext()
            completionHandler(true, nil)
        } catch let error {
            print(error.localizedDescription)
            completionHandler(false, error)
        }
    }
    
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).context
        return context
    }()
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            // let nserror = error as NSError
            // should toast for failed here
            // print("Primary Key duplicate")
        }
    }
    
    private func coreItemToItem(coreItem: NewsItem) -> News {
        var item = News()
        item.title = coreItem.title
        item.details = coreItem.details
        item.date = coreItem.date
        item.status = coreItem.status
        item.newsLink = coreItem.newsLink
        item.image = coreItem.image
        return item
    }
}
