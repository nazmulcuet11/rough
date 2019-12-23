//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by Nazmul Islam on 12/6/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var photoStore: PhotoStore!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoStore.fetchImage(for: photo) { imageResult -> Void in
            switch imageResult {
            case let .success(image):
                self.imageView.image = image
            case let .failure(error):
                print("Error fetching image for photo: \(error)")
            }
        }
    }
}
