//
//  Photo+CoreDataProperties.swift
//  Photorama
//
//  Created by Nazmul Islam on 20/6/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//
//

import Foundation
import CoreData


extension Photo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Photo> {
        return NSFetchRequest<Photo>(entityName: "Photo")
    }

    @NSManaged public var dateTaken: NSDate?
    @NSManaged public var photoID: String?
    @NSManaged public var remoteURL: NSURL?
    @NSManaged public var title: String?

}
