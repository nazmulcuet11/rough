//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Nazmul Islam on 10/6/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView!
    
    var photoStore: PhotoStore!
    var photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = photoDataSource

        updateDataSource()
        
        photoStore.fetchInterestingPhotos { (photoResult) -> Void in
//            switch photoResult {
//            case let .success(photos):
//                print("Successfully found \(photos.count) photos")
//                self.photoDataSource.photos = photos
//            case let .failure(error):
//                print("Error fetching interesting photos: \(error)")
//            }
//            self.collectionView.reloadSections(IndexSet(integer: 0))
            self.updateDataSource()
        }
        
//        photoStore.fetchPhotos(for: .recentPhotos) { (photoResult) -> Void in
//            switch photoResult {
//            case let .success(photos):
//                print("Successfully found \(photos.count) photos")
//                if let firstPhoto = photos.first {
//                }
//            case let .failure(error):
//                print("Error fetching interesting photos: \(error)")
//            }
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPhoto":
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                
                let destinationVC = segue.destination as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.photoStore = photoStore
            }
        default:
            preconditionFailure("Unexpected segue identifier!")
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        // This method is called when device orientation is changed
        super.traitCollectionDidChange(previousTraitCollection)
        // Need to change collection view cell width on device orientation change
        // So invalidating layout will recreate collection view cell and thus
        // adjust width of the cell
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func updateDataSource() {
        photoStore.fetchAllPhotos() { photoResult in
            switch photoResult {
            case let .success(photos):
                self.photoDataSource.photos = photos
            case let .failure(error):
                print("Error fetching all photos from core data: \(error)")
                self.photoDataSource.photos.removeAll()
            }
            self.collectionView.reloadSections(IndexSet(integer: 0))
        }
    }
}

extension PhotosViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        
        photoStore.fetchImage(for: photo) { imageResult -> Void in
            
            // The indexPath for the photo might have changed between the
            // time the request started and finished, so find most recent
            // indexPath
            
            guard let photoIndex = self.photoDataSource.photos.firstIndex(of: photo),
                case let .success(image) = imageResult else {
                    return
            }
            
            let photoIndexPath = IndexPath(item: photoIndex, section: 0)
            
            if let cell = collectionView.cellForItem(at: photoIndexPath) as?  PhotoCollectionViewCell {
                cell.update(with: image)
            }
        }
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = Int(UIScreen.main.bounds.width / 4)
        
        return CGSize(width: width, height: width)
    }
}
