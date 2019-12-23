//
//  ImageStore.swift
//  HomePwner
//
//  Created by Nazmul Islam on 28/5/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class ImageStore {
    let cache = NSCache<NSString, UIImage>()
    
    func imageURL(for key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        let url = imageURL(for: key)
        
        if let data = image.pngData() {
            try? data.write(to: url, options: .atomic)
        }
        
        cache.setObject(image, forKey: key as NSString)
    }
    
    func image(forKey key: String) -> UIImage? {
        if let exisitingImage = cache.object(forKey: key as NSString) {
            return exisitingImage
        }
        
        let url = imageURL(for: key)
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as NSString)
        return imageFromDisk
    }
    
    func deleteImage(forKey key: String) {
        cache.removeObject(forKey: key as NSString)
        let url = imageURL(for: key)
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print("Error removing image from \(url): \(error)")
        }
    }
}
