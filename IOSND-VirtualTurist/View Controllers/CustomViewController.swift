//
//  CustomViewController.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 6/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class CustomViewController: UIViewController,MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var deleteMessage: UILabel!
    
    var dataController:DataController!
    var clickedPin: Pin!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(gestureRecognizer)        // Do any additional setup after loading the view.
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        if let results = try? dataController.viewContext.fetch(fetchRequest){
            for pin in results {
                let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.setCenter(view.annotation!.coordinate, animated: true)
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        fetchRequest.fetchLimit = 1 // we expect to have a single pin in each location
        let latitudePredicate = NSPredicate(format: "latitude == %@", NSNumber( value: view.annotation!.coordinate.latitude))
        let longitudePredicate = NSPredicate(format: "longitude == %@", NSNumber(value: view.annotation!.coordinate.longitude))
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [latitudePredicate,longitudePredicate])
        fetchRequest.predicate = predicate
        if let pin = try? dataController.viewContext.fetch(fetchRequest) {
            clickedPin = pin[0]
            if deleteMessage.isHidden {
                performSegue(withIdentifier: "displayImagesSegue", sender: nil)
            } else {
                dataController.viewContext.delete(clickedPin)
                try? dataController.viewContext.save()
                mapView.removeAnnotation(view.annotation!)
            }
        }
    }
    
    @objc func handleTap(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            let location = gestureRecognizer.location(in: mapView)
            let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.setCenter(coordinate, animated: true)
            let pin = Pin(context: dataController.viewContext)
            pin.latitude = Double(coordinate.latitude)
            pin.longitude = Double(coordinate.longitude)
            try? dataController.viewContext.save()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayImagesSegue"{
            let imagesVC = segue.destination as! PhotoAlbumViewController
            imagesVC.centerCoordinate = mapView.centerCoordinate
            imagesVC.dataController = dataController
            imagesVC.pin = clickedPin
        }
    }
    @IBAction func deletePins(_ sender: Any) {
        deleteMessage.isHidden = !deleteMessage.isHidden
        
    }
}
