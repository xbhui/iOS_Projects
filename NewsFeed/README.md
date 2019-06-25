# NewsFeed

# Done
1. Fetch XML data , update to tableview
2. Local cache by core data, and support CRUD 
3. Item dispaly be sortable by published date
4. Display image if there's image, now has default imageview
5. Tap an item, open item's linke webview, user pan gesture  to swip back 
6. Read/unread state track
7. Allow search items by title fuzzy matching
8. Unit Tests (only a example of the coredate api now, will can implement more serously cases later)

# Todo
1. Optimize the network download part: image download, xml parser tool, network status check, seprate the basic network part with bussiness part
2. Global Error handle part, such as fetch data failed should provide user interaction or notify
3. Add daynamic cell view with image and without image, more flexible view arrangement
4. More clear code comments
5. Current fetch api always fetch the full 50 items, if can the api for find fetch by page or detla will much better


# Project Structure
├── NewsFeed
│   ├── AppEntry
│   │   ├── AppDelegate.swift
│   │   ├── Base.lproj
│   │   │   ├── LaunchScreen.storyboard
│   │   │   └── Main.storyboard
│   │   └── Info.plist
│   ├── Config
│   │   ├── Configure.swift
│   │   └── Constants.swift
│   ├── Helpers
│   │   ├── Network
│   │   │   └── HttpDownloadManager.swift
│   │   ├── UIComponents
│   │   │   └── NetImageView.swift
│   │   └── Utilities
│   │       ├── DateFormateUtility.swift
│   │       ├── NetworkReachability.swift
│   │       └── WebImage.swift
│   ├── HomeFeed
│   │   ├── Controllers
│   │   │   ├── FeedDetailsWebViewController.swift
│   │   │   └── HomeFeedViewController.swift
│   │   ├── Models
│   │   │   ├── APIManager.swift
│   │   │   ├── CoreDataManager.swift
│   │   │   ├── News.swift
│   │   │   ├── NewsFeed.xcdatamodeld
│   │   │   │   └── NewsFeed.xcdatamodel
│   │   │   │       └── contents
│   │   │   └── XMLParser.swift
│   │   └── Views
│   │       └── HomeFeedTableViewCell.swift
│   └── Resources
│       └── Assets.xcassets
│           ├── AppIcon.appiconset
│           │   └── Contents.json
│           └── Contents.json

