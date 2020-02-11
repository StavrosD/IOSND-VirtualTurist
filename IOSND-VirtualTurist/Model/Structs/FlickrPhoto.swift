//
//  FlickrPhoto.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 8/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
struct FlickrPhoto:Codable {
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
    var imageURL:String {
        get {
        return "https://farm\(self.farm).staticflickr.com/\(self.server)/\(self.id)_\(self.secret)_m.jpg"
        }
    }
}

