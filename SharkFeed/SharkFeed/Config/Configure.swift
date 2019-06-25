//
//  Configure.swift
//  SharkFeed
//
//  Created by gauss on 6/14/19.
//  Copyright © 2019 xiubao. All rights reserved.
//

let APIKEY = "99685be3c9f3976e4e2db1763ca62022"

let urlHomeFeedPhotosPrefix =
"https://api.flickr.com/services/rest/?method=flickr.photos" +
".search&api_key=\(APIKEY)&text=shark&format=json&nojsoncallback=1&page="
let urlHomeFeedPhotosParameter = 1
let urlHomeFeedPhotosSuffix = "&extras=url_t,url_c,url_l,url_o"

let urlHomeFeedPhotoInfoPrefix =
"https://api.flickr.com/services/rest/?method=flickr.photos.getInfo&api_key=\(APIKEY)&photo_id="
let urlHomeFeedPhotoInfoPhotoid = 1
let urlHomeFeedPhotoInfoSuffix = "&format=json&nojsoncallback=1.json"
