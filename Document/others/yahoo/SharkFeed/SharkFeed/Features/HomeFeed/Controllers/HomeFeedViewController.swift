//
//  HomeFeedViewController.swift
//  SharkFeed
//
//  Created by gauss on 6/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit

class HomeFeedViewController: UICollectionViewController {

    var photosDetails: [PhotosDetail] = []
    var thumbnailImages: NSMutableDictionary = NSMutableDictionary()
    var pageLoaded: Int = numFirstPage
    var refreshHeader: RefreshViewHeader?
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        let layout = HomeFeedViewFlowLayout()
        super.init(collectionViewLayout: layout)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidAppear(_ animated: Bool) {
        let title = NavbarTitleLabel.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        title.setup(title: "SharkFeed")
        self.navigationItem.titleView = title
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .none
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setRefreshViews()
        setCollectView()
        // Downlaod items, then update view
        getPhotoIdsFromServer(pageToLoad: pageLoaded+1)
    }
    func setRefreshViews() {
        self.view.autoresizesSubviews = true
        refreshHeader = RefreshViewHeader.init(frame: CGRect(x: 0, y: 0,
            width: self.view.bounds.width, height: 0))
        refreshHeader?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        refreshHeader?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.collectionView.refreshControl = refreshHeader
    }
    @objc func refresh(refreshCntrl: UIRefreshControl) {
        photosDetails.removeAll()
        thumbnailImages.removeAllObjects()
        getPhotoIdsFromServer(pageToLoad: numFirstPage)
        refreshHeader?.endRefreshing()
    }
    func setCollectView() {
        self.collectionView.backgroundColor = .white
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.autoresizesSubviews = true
        self.collectionView?.register(HomeCollectionViewCell.self,
                                      forCellWithReuseIdentifier: HomeCollectionViewCell.identifer)
        self.collectionView?.register(RefreshViewHeader.self, forSupplementaryViewOfKind:
            UICollectionView.elementKindSectionHeader, withReuseIdentifier: RefreshViewHeader.identifer)
    }
}

extension HomeFeedViewController: UICollectionViewDelegateFlowLayout {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photosDetails.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            HomeCollectionViewCell.identifer, for: indexPath)
        if indexPath.row > self.photosDetails.count {
            return cell
        }

        // should check the data valid here
        guard let urlt = photosDetails[indexPath.row].imgURLt as String? else { return cell}
        let imgView = UIImageView.init(frame:
            CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        let cellImage = thumbnailImages.object(forKey: urlt as Any)
        if cellImage != nil {
            imgView.image = cellImage as? UIImage
        } else {
            imgView.image = UIImage.init(named: imgHomesharkdefault)
        }
        
        cell.backgroundView = imgView
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = photosDetails[indexPath.row]
        let detailViewController = HomeFeedDetailViewController()
        detailViewController.photoDetail = detail
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.size.width, height: 10)
    }
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            // reached bottom
            pageLoaded += 1
            self.getPhotoIdsFromServer(pageToLoad: pageLoaded)
        }
    }
}

extension HomeFeedViewController {
    func getPhotoIdsFromServer(pageToLoad: Int) {
        let request = HttpDownloadManager.sharedInstance
        let urlHomeFeedPhotos = String(format: "%@%d%@",
            urlHomeFeedPhotosPrefix, pageToLoad, urlHomeFeedPhotosSuffix)
        request.getSessionDataTask(url: urlHomeFeedPhotos) { (response, error) in
            do {
                self.parsePhotosresponse(response: response)
                print(error as Any)
            }
        }
    }
    func parsePhotosresponse(response: NSDictionary) {
        guard let photosDict = response["photos"] as? NSDictionary else { return }
        guard let photosArray = photosDict["photo"] as? NSArray else { return }
        print(photosDict)
        for photo in photosArray {
            guard let dict = photo as? NSDictionary else { return }
            guard let photoid = dict.value(forKey: "id") as? String else { return }
            guard let title = dict.value(forKey: "title") as? String else { return }
            let imgURLt = dict["url_t"] != nil ? dict["url_t"]:""
            let imgURLc = dict["url_c"] != nil ? dict["url_c"]:""
            let imgURLo = dict["url_o"] != nil ? dict["url_o"]:""
            let detailItem = PhotosDetail(photoid: photoid,
                imgURLt: imgURLt as? String, imgURLc: imgURLc as? String,
                imgURLo: imgURLo as? String, photoTitle: title, photoDescription: "", photoPageurl: "")
            self.photosDetails.append(detailItem)
        }

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        loadThumbnailImages()
    }
    func loadThumbnailImages() {
        for detail in self.photosDetails {
            let turl = detail.imgURLt! as String
            HttpDownloadManager.sharedInstance.downloadImageTask(urlStr: turl) { (image, error) -> Void in
                DispatchQueue.main.async {
                    self.thumbnailImages[turl] = image
                    self.collectionView.reloadData()
                }
                print(error as Any)
            }
        }
    }
}
