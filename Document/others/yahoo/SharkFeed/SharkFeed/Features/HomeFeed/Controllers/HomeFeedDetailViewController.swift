//
//  HomeFeedDetailViewController.swift
//  SharkFeed
//
//  Created by gauss on 6/15/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

import UIKit
import Photos

class HomeFeedDetailViewController: UIViewController, UIGestureRecognizerDelegate {

    var photoDetail: PhotosDetail
    var detailView: HomeFeedDetailView
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        self.getPhotoInfoFromServer(photoid: photoDetail.photoid)
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
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
        self.view.backgroundColor = .white
        getLargeImageFromServer(url: photoDetail.imgURLc)
        detailView = HomeFeedDetailView()
        detailView.delegate = self
        self.view = detailView
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight,
                                      .flexibleLeftMargin, .flexibleRightMargin, .flexibleBottomMargin]
        self.view.autoresizesSubviews = true
        detailView.frame = self.view.bounds
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func getLargeImageFromServer(url: String) {
        HttpDownloadManager.sharedInstance.downloadImageTask(urlStr: url) { (image, error) -> Void in
            DispatchQueue.main.async {
                self.detailView.updateView(image: image)
            }
            print(error as Any)
        }
    }
    init() {
        self.detailView = HomeFeedDetailView()
        self.photoDetail = PhotosDetail()
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        self.detailView = HomeFeedDetailView()
        self.photoDetail = PhotosDetail()
        super.init(coder: aDecoder)
    }
}

// Mark - details view actions delegate
extension HomeFeedDetailViewController: HomeFeedDetailViewActionDelegate {
    func handleSaveImageAction() {
        // download the original image, then save it to camera roll
        guard let image = detailView.photoDisplay.image else { return }
        // also can use this way: UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        }, completionHandler: { (isSuccess: Bool, error: Error?) in
            self.showMessage(isSuccess: isSuccess, error: error)
        })
    }
    func handleOpenFlickrPage() {
        guard let pageUrl = photoDetail.photoPageurl as String? else { return }
        if let url = URL(string: pageUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: {(success) in
                print(success as Any)
            })
        }
    }
    func handlePhotoPinchAction(pinGesture: UIPinchGestureRecognizer ) {
        guard pinGesture.view != nil else { return }
        if pinGesture.state == .began || pinGesture.state == .changed {
            pinGesture.view?.transform =
                (pinGesture.view?.transform.scaledBy(x: pinGesture.scale, y: pinGesture.scale))!
            pinGesture.scale = 1.0
        }
    }
    func showMessage(isSuccess: Bool, error: Error?) {
        DispatchQueue.main.async {
            if isSuccess {
                MessageToast.show(message: toastMessageSuccess, controller: self)
            } else {
                MessageToast.show(message: toastMessageFailed + error!.localizedDescription, controller: self)
            }
        }
    }
}

// Mark - data download from server and process
extension HomeFeedDetailViewController {
    func getPhotoInfoFromServer(photoid: String) {
        let request = HttpDownloadManager.sharedInstance
        let urlHomeFeedPhotoInfo = String(format: "%@%@%@",
        urlHomeFeedPhotoInfoPrefix, photoid, urlHomeFeedPhotoInfoSuffix)
        print(urlHomeFeedPhotoInfo)
        request.getSessionDataTask(url: urlHomeFeedPhotoInfo) { (response, error) in
            do {
                // should check the "stat here
                self.parsePhotosresponse(response: response)
                print(error as Any)
            }
        }
    }
    func parsePhotosresponse(response: NSDictionary) {
        guard let photoDict = response["photo"] as? NSDictionary else { return }
        guard let desDict = photoDict["description"] as? NSDictionary else { return }
        guard let description = desDict["_content"] as? String else { return }
        self.photoDetail.photoDescription = description
        guard let urlDict = photoDict["urls"] as? NSDictionary else { return }
        guard let urlArray =  urlDict["url"] as? NSArray else { return }
        for url in urlArray {
            guard let dict = url as? NSDictionary else { return }
            guard let type = dict["type"] as? String  else { return }
            if  type == "photopage" {
                guard let pageurl = dict["_content"] as? String else {return }
                self.photoDetail.photoPageurl = pageurl
            }
        }
    }
}

// Mark - gestures on the detail view
extension HomeFeedDetailViewController {
    func handle(recognizer: UIPinchGestureRecognizer) {
        let view = recognizer.view
        if recognizer.state == .began || recognizer.state == .changed {
            view?.transform = .identity
            recognizer.scale = 1
        }
    }
}
