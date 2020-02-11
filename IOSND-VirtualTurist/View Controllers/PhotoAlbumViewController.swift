
//
//  ImagesViewController.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 8/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, AlertProtocol {
    
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    var centerCoordinate: CLLocationCoordinate2D?
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var newCollectionButton: UIButton!
    var dataController:DataController!
    var pin:Pin!
    var photoFetchResultsController: NSFetchedResultsController<Photo>!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.centerCoordinate = centerCoordinate!
        let annotation = MKPointAnnotation()
        annotation.coordinate = centerCoordinate!
        mapView.addAnnotation(annotation)
        // Register cell class
        // Setup the view
        let space:CGFloat = 1.0
        let columns:CGFloat = 3.0
        let dimension = (collectionView.frame.size.width - (2.0 * space))/columns
    
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height:dimension )
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setupFetchedResultsController()
        if photoFetchResultsController.fetchedObjects?.count == 0 {
                   fetchNewCollection(self)
               }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionViewCell
        let aPhoto = photoFetchResultsController.object(at: indexPath)
        if let cellImage = aPhoto.image {
            cell.flickrImage.image = UIImage(data: cellImage)
            cell.activityIndicator.stopAnimating()
        } else {
            cell.flickrImage.image = nil
            cell.activityIndicator.startAnimating()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Warning", message: "Do you want to delete this image?", preferredStyle: .alert)
        alert.addAction( UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            self.deletePhoto(at: indexPath)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            
        })
        self.present(alert,animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photoFetchResultsController.sections?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      let itemsCount = photoFetchResultsController.sections?[section].numberOfObjects ?? 0
    return itemsCount
    }
    
    // Callback to update the UI after downloading the images
    func refreshUI(successStatus: Bool, errorMessage: String?, photos: FlickrPhotos?){
        if successStatus == true {
            for photoInfo in photos!.photo {
                let photo = Photo(context: dataController.viewContext)
                photo.imageUrl = photoInfo.imageURL
                pin.addToPhotos(photo)
            }
            try? dataController.viewContext.save()
            DispatchQueue.main.async {
            self.newCollectionButton.isEnabled = true
            }
            NetworkClient.AsyncDownloadAndSaveImages( pin: pin, dataController: dataController)
        } else {
            DispatchQueue.main.async {
                self.alert(message: errorMessage!)
                self.newCollectionButton.isEnabled = true
            }
        }
    }
    
    // Get new images from flickr
    @IBAction func fetchNewCollection(_ sender: Any) {
        newCollectionButton.isEnabled = false
        if pin!.photos!.count > 0  {
            collectionView.performBatchUpdates({
            pin!.removeFromPhotos(pin!.photos!)
            try? dataController.viewContext.save()      // save changes to the data context
                }, completion: nil)
        }
        NetworkClient.GetFlickrPhotos(latitude: centerCoordinate!.latitude, longitude: centerCoordinate!.longitude,  completion: refreshUI)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        photoFetchResultsController = nil
    }
}
