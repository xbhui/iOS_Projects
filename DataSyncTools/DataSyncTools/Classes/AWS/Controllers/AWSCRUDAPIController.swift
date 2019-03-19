//
//  AWSCRUDAPIController.swift
//  DataSyncTools
//
//  Created by gauss on 2/12/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import AWSAppSync


class AWSCRUDAPIController: UIViewController {
    
    var table:UITableView! = UITableView()
    var eventList: [ListEventsQuery.Data.ListEvent.Item?] = []
    var appSyncClient: AWSAppSyncClient?
    var fixedLimit: Int = 20 // predefined pagination size
    var nextToken: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appSyncClient = appDelegate.appSyncClient
        setupView()
        
        fetchAllEventsUsingCachePolicy(.returnCacheDataAndFetch)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        nextToken = nil
       // reloadData()
    }

    func setupView() {
        self.title = "Events"
        
        let rightItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addEvent(sender:))
        )
        self.navigationItem.rightBarButtonItem = rightItem
        
        table = UITableView.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), style: .plain)
        table.delegate = self
        table.dataSource = self
        self.view.addSubview(table)
    }
    
    @objc func addEvent(sender: AnyObject) {
        print("and event")
        let selectController = AddEventViewController()
        self.navigationController?.pushViewController(selectController, animated: true)
    }
    // MARK: - Queries
    func fetchAllEventsUsingCachePolicy(_ cachePolicy: CachePolicy) {

        let listQuery = ListEventsQuery(limit: fixedLimit, nextToken: nextToken)
        
        appSyncClient?.fetch(query: listQuery, cachePolicy: cachePolicy) { (result, error) in
          //  self.refreshControl.endRefreshing()
            
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            
            // Remove existing records if we're either loading from cache, or loading fresh (e.g., from a refresh)
            if self.nextToken == nil && cachePolicy == .returnCacheDataAndFetch {
                self.eventList.removeAll()
            }
            
            self.eventList.append(contentsOf: result?.data?.listEvents?.items ?? [])
            self.table.reloadData()
            
            self.nextToken = result?.data?.listEvents?.nextToken
        }
    }
}

// MARK: - Table view delegates
extension AWSCRUDAPIController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = EventCell.init(style: .subtitle, reuseIdentifier: "cellIdentifier")
        guard let event = eventList[indexPath.row] else {
            return cell
        }
        cell.updateEvent(eventName: event.name, when: event.when, where: event.where)

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    // editing action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == UITableViewCell.EditingStyle.delete) {
            guard let id = eventList[indexPath.row]?.id else {
                return
            }
            let deleteEventMutation = DeleteEventMutation(id: id)
            
            appSyncClient?.perform(mutation: deleteEventMutation, optimisticUpdate: { (transaction) in
                do {
                    // Update our normalized local store immediately for a responsive UI.
                    try transaction?.update(query: ListEventsQuery()) { (data: inout ListEventsQuery.Data) in
                        // remove event from local cache.
                        let newState = data.listEvents?.items?.filter({$0?.id != id })
                        data.listEvents?.items = newState
                    }
                } catch {
                    print("Error removing the object from cache with optimistic response.")
                }
            }) { result, error in
                if let result = result {
                    print("Successful response for delete: \(result)")
                    
                    // refresh updated list in main thread
                    self.eventList.remove(at: indexPath.row)
                    self.table.reloadData()
                } else if let error = error {
                    print("Error response for delete: \(error)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  self.lastOpenedIndex = indexPath.row
        guard let event = eventList[indexPath.row] else {
            return
        }
        
        let detail = EventDetailsViewController()
        detail.event = event.fragments.event
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    // pagination
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > eventList.count - 2 &&
            self.nextToken?.count ?? 0 > 0 {
            fetchAllEventsUsingCachePolicy(.fetchIgnoringCacheData)
        }
    }
}
