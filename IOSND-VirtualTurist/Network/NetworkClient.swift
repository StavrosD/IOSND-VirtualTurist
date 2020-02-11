//
//  NetworkClient.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 8/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class NetworkClient {
    static let apiKey: String = "2c103aff75ee159856680c425f74c9cb"
    class func GetFlickrPhotos(latitude: Double, longitude: Double, completion: @escaping (Bool, String?, FlickrPhotos?)->Void){
        let baseURL = "https://api.flickr.com/services/rest/?api_key=\(apiKey)&method=flickr.photos.search&lat=\(latitude)&lon=\(longitude)&format=json&nojsoncallback=1&per_page=12&page=\(Int.random(in: 1...3))"
        let task = URLSession.shared.dataTask(with:URL(string: baseURL)!, completionHandler:  { data, response, error -> Void in
            if error != nil {
                completion(false,error?.localizedDescription, nil)
                return
            }
            if let data = data{
                if let flickrPostResponse = try? JSONDecoder().decode(FlickrPostResponse.self, from: data){
                    
                    completion(true,nil, flickrPostResponse.photos!)
                    return
                }// end if flickrPostResponse
            } //end if let data
            completion(false, "Cannot get images!",nil )
        } // end completionHandler
        )
        task.resume()
    }
    
    class  func DownloadImage (photo:Photo, dataController: DataController, completion: ((Bool,String?)->Void)?) {
        let task = URLSession.shared.dataTask(with:URL(string: photo.imageUrl!)!, completionHandler:  { data, response, error -> Void in
            if error != nil {
                completion?(false,error?.localizedDescription )
                return
            }
            if let data = try? Data(contentsOf: URL(string: photo.imageUrl!)!) {
                photo.image = data
                try? dataController.viewContext.save()
                completion?(true,nil)
                return
            }
            completion?(false, "Cannot get images!")
        }
        )
        task.resume()
    }
    class func AsyncDownloadAndSaveImages (pin:Pin, dataController: DataController) {
        for photo in pin.photos!.allObjects as! [Photo] {
            NetworkClient.DownloadImage(photo: photo , dataController: dataController,completion: nil)
        }
    }
}
