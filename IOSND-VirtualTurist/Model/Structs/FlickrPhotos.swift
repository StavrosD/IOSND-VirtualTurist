//
//  FlickrPhotos.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 8/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
struct FlickrPhotos:Codable {
    var page: Int
    var pages: Int
    var perpage: Int
    var total: String
    var photo: [FlickrPhoto]
}
