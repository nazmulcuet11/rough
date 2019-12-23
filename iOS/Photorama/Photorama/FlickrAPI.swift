//
//  FlickrAPI.swift
//  Photorama
//
//  Created by Nazmul Islam on 10/6/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import Foundation
import CoreData

enum FlickrError: Error {
    case invalidJSONData
}

enum Method: String {
    case interestingPhotos = "flickr.interestingness.getlist"
    case recentPhotos = "flickr.photos.getrecent"
}

struct FlickrAPI {
    private static let baseURLString = "https://api.flickr.com/services/rest/"
    private static let apiKey = "f94d746e56d2185f71fa65b9bb951c7b"
    private static let apiSecret = "9aeaca358bc82e4e"
    
    static var interestingPhotosURL: URL {
        return flickrURL(method: .interestingPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    static func url(for method: Method) -> URL {
        return flickrURL(method: method, parameters: ["extras": "url_h,date_taken"])
    }
    
    private static let dateFormater: DateFormatter = {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formater
    }()
    
    
    private static func flickrURL(method: Method, parameters: [String: String]?) -> URL {
        var components = URLComponents(string: baseURLString)!
        var queryItems = [URLQueryItem]()
        
        let baseParams = [
            "method": method.rawValue,
            "format": "json",
            "nojsoncallback": "1",
            "api_key": apiKey
        ]
        
        for (key, value) in baseParams {
            let item = URLQueryItem(name: key, value: value)
            queryItems.append(item)
        }
        
        if let additionalParams = parameters {
            for (key, value) in additionalParams {
                let item = URLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
        }
        components.queryItems = queryItems
        
        return components.url!
    }
    
    private static func photo(from json: [String: Any], into context: NSManagedObjectContext) -> Photo? {
        guard let photoID = json["id"] as? String,
            let title = json["title"] as? String,
            let dateString = json["datetaken"] as? String,
            let photoURLString = json["url_h"] as? String,
            let url = URL(string: photoURLString),
            let dateTaken = dateFormater.date(from: dateString) else {
                return nil
        }

        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate(format: "\(#keyPath(Photo.photoID)) == \(photoID)")
        fetchRequest.predicate = predicate

        var fetchedPhotos: [Photo]?
        context.performAndWait {
            fetchedPhotos = try? fetchRequest.execute()
        }

        if let existingPhoto = fetchedPhotos?.first {
            return existingPhoto
        }

        var photo: Photo!
        context.performAndWait {
            photo = Photo(context: context)
            photo.photoID = photoID
            photo.title = title
            photo.remoteURL = url as NSURL
            photo.dateTaken = dateTaken as NSDate
        }
        
        return photo
    }
    
    static func photos(from jsonData: Data, into context: NSManagedObjectContext) -> PhotoResult {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: [])
            print(jsonObject)
            
            guard
                let jsonDictionary = jsonObject as? [AnyHashable: Any],
                let photos = jsonDictionary["photos"] as? [String: Any],
                let photosArray = photos["photo"] as? [[String: Any]] else {
                    return .failure(FlickrError.invalidJSONData)
            }
            
            var finalPhotos = [Photo]()
            for photoJSON in photosArray {
                if let photo = photo(from: photoJSON, into: context) {
                    finalPhotos.append(photo)
                }
            }
            
            if finalPhotos.isEmpty && !photosArray.isEmpty {
                return .failure(FlickrError.invalidJSONData)
            }
            
            return .success(finalPhotos)
        } catch let error {
            print("Error pasrsing json: \(error)")
            return .failure(error)
        }
    }
}
