//
//  EventDetailsViewController.swift
//  DataSyncTools
//
//  Created by gauss on 2/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import Foundation
import UIKit
import AWSAppSync

class EventDetailsViewController: UIViewController {
    
    private var eventlabel: UILabel!
    private var whenlabel: UILabel!
    private var wherelabel: UILabel!
    private var descriptionLabel: UILabel!
    
    private var v_eventlabel: UILabel!
    private var v_whenlabel: UILabel!
    private var v_wherelabel: UILabel!
    private var v_descriptionLabel: UILabel!
    
    private var commentLab: UILabel!
    
    var table:UITableView! = UITableView()
    // The event to display
    var event: Event?
    // The app's AppSyncClient, used to fetch initial comment data and subscribe to new comments
    var appSyncClient: AWSAppSyncClient?
    // This subscription watcher is retained for the life of the ViewController. Releasing a subscription watcher means
    // that its handler will no longer be invoked when AppSync detects a change
    var newCommentsSubscriptionWatcher: AWSAppSyncSubscriptionWatcher<NewCommentOnEventSubscription>?
    
    var comments: [Event.Comment.Item?] = [] {
        didSet {
            table.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        fetchEventFromServer()
        
        do {
            try startSubscriptionForEvent()
        } catch {
            print("Error subscribing to events: \(error)")
        }

    }
    func setupView() {
        
        self.title = "Even Details"
        eventlabel = addleftLabel(toporign: 80, left: 20, width: 80, txt: "Event", side: .left)
        whenlabel = addleftLabel(toporign: 110, left: 20, width: 80, txt: "When", side: .left)
        wherelabel = addleftLabel(toporign: 140, left: 20, width: 80, txt: "Where", side: .left)
        descriptionLabel = addleftLabel(toporign: 170, left: 20, width: 80, txt: "Description", side: .left)
        
        if let event = event {
            v_eventlabel = addleftLabel(toporign: 80, left: 130, width: 200, txt: event.name ?? "", side: .left)
            v_whenlabel = addleftLabel(toporign: 110, left: 130, width: 200, txt: event.when ?? "", side: .left)
            v_wherelabel = addleftLabel(toporign: 140, left: 130, width: 200, txt: event.where ?? "", side: .left)
            v_descriptionLabel = addleftLabel(toporign: 170, left: 130, width: 200, txt: event.description ?? "", side: .left)
            addCommentLabel()
            comments = event.comments?.items ?? []
        }
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New Comment", style: .plain, target: self, action: #selector(addComment))
        
        table = UITableView.init(frame: CGRect(x: 0, y: 80+30+30+30+40+30, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
        
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("Cancelling subscription")
        newCommentsSubscriptionWatcher?.cancel()
    }
    
    // MARK: - Queries
    func fetchEventFromCache() {
        doFetchWithCachePolicy(.returnCacheDataDontFetch)
    }
    
    func fetchEventFromServer() {
        doFetchWithCachePolicy(.fetchIgnoringCacheData)
    }
    
    func doFetchWithCachePolicy(_ cachePolicy: CachePolicy) {
        guard let event = event else {
            print("Event is nil, not fetching")
            return
        }
        
        let eventQuery = GetEventQuery(id: event.id)
        
        // Fetch defaults to invoking callbacks on the main queue, so the assignment to `self.comments` below is safe
        appSyncClient?.fetch(query: eventQuery, cachePolicy: cachePolicy) { (result, error) in
            guard error == nil else {
                print("Error fetching event: \(error!.localizedDescription)")
                return
            }
            
            guard let event = result?.data?.getEvent?.fragments.event else {
                print("Event data nil fetching")
                return
            }
            self.event = event
            
            guard let comments = event.comments?.items else {
                print("Comments nil fetching event")
                return
            }
            self.comments = comments
        }
    }
    
//Mark subscription 
    
    func startSubscriptionForEvent() throws {
        guard let eventId = event?.id else {
            print("Event is nil, not starting subscription")
            return
        }
        print("Starting subscription for event: \(eventId)")
        
        let subscriptionRequest = NewCommentOnEventSubscription(eventId: eventId)
        
        // When we receive a new comment via subscription, AppSync will automatically cache the new comment object
        // itself (assuming it is valid). However, we must manually update the relationship between the parent event
        // and the new comment. Rather than re-query the service for the updated object, we will update the cache
        // locally with the incoming data.
        newCommentsSubscriptionWatcher = try appSyncClient?.subscribe(subscription: subscriptionRequest) { [weak self] (result, transaction, error) in
            print("Received comment subscription callback on event \(eventId)")
            
            guard let self = self else {
                print("EventDetails view controller has been deallocated since subscription was started, aborting")
                return
            }
            
            guard let event = self.event else {
                print("Event has been deallocated since the subscription was started, aborting")
                return
            }
            
            guard error == nil else {
                print("Error in comment subscription for event \(event.id): \(error!.localizedDescription)")
                return
            }
            
            guard let result = result else {
                print("Result unexpectedly nil in comment subscription for event \(event.id)")
                return
            }
            
            guard let graphQLResponseData = result.data?.subscribeToEventComments else {
                print("GraphQL response data unexpectedly nil in comment subscription for event \(event.id)")
                return
            }
            
            print("Received new comment on event \(event.id)")
            
            let content = graphQLResponseData.content
            let commentId = graphQLResponseData.commentId
            let createdAt = graphQLResponseData.createdAt
            let eventId = graphQLResponseData.eventId
            
            // This will be the new object to add to the local cache for the event->comment relationship
            var comments: GetEventQuery.Data.GetEvent.Comment?
            if var previousComments = event.comments {
                let newCommentData = CommentOnEventMutation.Data.CommentOnEvent(
                    eventId: eventId,
                    content: content,
                    commentId: commentId,
                    createdAt: createdAt)
                let newCommentObject = Event.Comment.Item(snapshot: newCommentData.snapshot)
                previousComments.items?.append(newCommentObject)
                comments = GetEventQuery.Data.GetEvent.Comment(snapshot: previousComments.snapshot)
            } else {
                // Note that this is the same data as, but a different structure than, the `newCommentObject` above
                let commentItem = GetEventQuery.Data.GetEvent.Comment.Item(
                    eventId: eventId,
                    commentId: commentId,
                    content: content,
                    createdAt: createdAt)
                comments = GetEventQuery.Data.GetEvent.Comment(items: [commentItem])
            }
            
            let eventData = GetEventQuery.Data.GetEvent(id: eventId,
                                                        description: event.description,
                                                        name: event.name,
                                                        when: event.when,
                                                        where: event.where,
                                                        comments: comments)
            
            do {
                // Write new event object to the store
                try transaction?.write(object: eventData, withKey: eventId)
                
                // reload data from cache, which will also reload the table view
                self.fetchEventFromCache()
            } catch {
                print("Error occurred while updating store during comment subscription: \(error)")
            }
            
        }
    }
    
    @objc func addComment() {
        let alertController = UIAlertController(title: "New Comment", message: "Type in your thoughts.", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { _ in
            guard let event = self.event else {
                return
            }
            
            guard let comment = alertController.textFields?[0].text, !comment.isEmpty else {
                return
            }
            
            let mutation = CommentOnEventMutation(eventId: event.id, content: comment, createdAt: Date().description)
            
            self.appSyncClient?.perform(mutation: mutation)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Type the comment here..."
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addleftLabel(toporign:CGFloat, left:CGFloat, width:CGFloat, txt:String,side:NSTextAlignment) -> (UILabel){
        let lab = UILabel(frame: CGRect(x: left, y: toporign, width:  width, height: 30))
//        lab.backgroundColor = UIColor.red
        lab.textColor = UIColor.black
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textAlignment = side
        lab.text = txt
        self.view.addSubview(lab)
        return lab
    }
    
    func addCommentLabel(){
        let lab = UILabel(frame: CGRect(x: 0, y: 210, width:  UIScreen.main.bounds.width, height: 30))
     //   lab.backgroundColor = UIColor.red
        lab.textColor = UIColor.black
        lab.font = UIFont.boldSystemFont(ofSize: 15)
        lab.textAlignment = .center
        lab.text = "Comments"
        self.view.addSubview(lab)
    }
}


// MARK: - Table view delegates

extension EventDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = CommentCell.init(style: .subtitle, reuseIdentifier: "cellIdentifier")
        guard let content = comments[indexPath.row]?.content else {
            print("No comment at indexPath \(indexPath)")
            return cell
        }
        
       cell.commentContent.text = content
        return cell
        
    }
}
