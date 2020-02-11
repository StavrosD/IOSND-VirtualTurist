//
//  PhotoAlbumViewControllerExtension.swift
//  IOSND-VirtualTurist
//
//  Created by Dimopoulos Stavros tou Athanasiou on 10/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import CoreData

extension PhotoAlbumViewController:NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            collectionView.insertItems(at: [newIndexPath!])
            break
        case .delete:
            collectionView.deleteItems(at: [indexPath!])
            break
        case .update:
            collectionView.reloadItems(at: [indexPath!])
        case .move:
            collectionView.moveItem(at: indexPath!, to: newIndexPath!)
        @unknown default:
            fatalError("NSFetchedResultsController did change")
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        let indexSet = IndexSet(integer: sectionIndex)
        switch type {
        case .insert: collectionView.insertSections (indexSet)
        case .delete: collectionView.deleteSections(indexSet)
        case .update, .move:
            fatalError("Invalid change type in controller(_:didChange:atSectionIndex:for:). Only .insert or .delete should be possible.")
        @unknown default:
            fatalError("Unsupported NSFetchedResultsController didChange section  ")
        }
    }
    
    func setupFetchedResultsController() {
        let fetchRequest:NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "pin == %@", pin)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "imageUrl", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        photoFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        photoFetchResultsController.delegate = self
        do {
            try photoFetchResultsController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
       
    }
    
    func deletePhoto(at indexPath: IndexPath){
        let photoToDelete = photoFetchResultsController.object(at: indexPath)
        dataController.viewContext.delete(photoToDelete)
        try? dataController.viewContext.save()
    }
}
