//
//  HomeFeedViewController.swift
//  NewsFeed
//
//  Created by gauss on 6/21/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HomeFeedViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var newsItems = [News]()
    let apiManager = APIManager.shared
    var searchText = String()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupAPIManager()
        setupSearchBar()
        // Load the latest 50 feed items from cache
        self.loadLocalFeed()
        // Fetch the latest 50 feed items, then store to local
        self.loadLatestFeed()
    }
}

// MARK - Load latest Feed with XML
extension HomeFeedViewController: APIManagerDelegate {
    private func setupAPIManager() {
        self.apiManager.delegate = self
    }
    
    private func loadLocalFeed() {
        CoreDataManager.shared.fetchNewsItemList { (result, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.newsItems = result;
                    self.tableView.reloadData()
                }
            } else {
                print("fetchNewsItemList error")
            }
        }
    }
    
    private func loadLatestFeed() {
        // here should check the network connect or not
        self.apiManager.XMLBeginParsing()
    }
    
    private func updateReadStatus(selectIdx: IndexPath) {
        let link = newsItems[selectIdx.row].newsLink!
        CoreDataManager.shared.updateNewsItem(newsLink: link) { (sucess, error) in
            if sucess {
                self.newsItems[selectIdx.row].status = 1
                self.tableView.reloadRows(at: [selectIdx], with: UITableView.RowAnimation.none)
            }else {
                print("error")
            }
        }
    }
    
    func parsingDidSucceed(result: [News]) {
        // save feed items to cache, then update to display
        CoreDataManager.shared.writeNewsItem(newsList: result) { (newsList, error) -> Void in
            DispatchQueue.main.async {
                if error == nil {
                    self.loadLocalFeed()
                }
            }
        }
    }

    func parsingDidFail(error: NSError) {
        // should toast show the failed here
        print("\(String(describing: error))")
    }
}

// MARK - Table View Data Source
extension HomeFeedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier.identifier) as? HomeFeedTableViewCell {
            let row = indexPath.row
            let news = newsItems[row]
            cell.configurateTheCell(news)
            return cell
        }
        return UITableViewCell()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.seguedentifier.identifier {
            let detailsVC = segue.destination as! FeedDetailsWebViewController
            let cell = sender as! HomeFeedTableViewCell
            let indexPath = self.tableView!.indexPath(for: cell)
            let selectRow = indexPath?.row
            detailsVC.newsLink = newsItems[selectRow!].newsLink
            self.updateReadStatus(selectIdx: indexPath!)
        }
    }
}

// MARK - UISearchBarDelegate
extension HomeFeedViewController: UISearchBarDelegate {
    private func setupSearchBar() {
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search by news title"
        self.searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
           self.searchText = searchText
        }else {
            searchBar.resignFirstResponder()
            self.loadLocalFeed()
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if searchText == "" {
                return
        }
        
        CoreDataManager.shared.getNewsItem(title: searchText) { (newsList, error) in
            DispatchQueue.main.async {
                if error == nil {
                    self.newsItems = newsList
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.loadLocalFeed()
    }
}

