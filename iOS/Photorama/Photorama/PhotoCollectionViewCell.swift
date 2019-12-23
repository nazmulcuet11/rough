//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by Nazmul Islam on 12/6/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    
    func update(with image: UIImage?) {
        if let image = image {
            spinner.stopAnimating()
            imageView.image = image
        } else {
            spinner.startAnimating()
            imageView.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        update(with: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        update(with: nil)
    }
}
