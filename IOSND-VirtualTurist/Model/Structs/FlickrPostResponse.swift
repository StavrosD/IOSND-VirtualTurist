//
//  PostResponse.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 9/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
struct FlickrPostResponse:Codable {
    var photos: FlickrPhotos?
    var stat: String
}
