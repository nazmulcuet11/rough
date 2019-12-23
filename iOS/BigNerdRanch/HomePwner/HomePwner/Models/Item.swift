//
//  Items.swift
//  HomePwner
//
//  Created by Nazmul Islam on 8/3/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    let itemKey: String
    
    // MARK: Archive Key
    let keyForName = "name"
    let keyForValueInDollars = "valueInDollars"
    let keyForSerialNumber = "serialNumber"
    let keyForDateCreated = "dateCreated"
    let keyForItemKey = "itemKey"
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: keyForName) as! String
        self.valueInDollars = aDecoder.decodeInteger(forKey: keyForValueInDollars)
        self.serialNumber = aDecoder.decodeObject(forKey: keyForSerialNumber) as? String
        self.dateCreated = aDecoder.decodeObject(forKey: keyForDateCreated) as! Date
        self.itemKey = aDecoder.decodeObject(forKey: keyForItemKey) as! String
        
        super.init()
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: keyForName)
        aCoder.encode(valueInDollars, forKey: keyForValueInDollars)
        aCoder.encode(serialNumber, forKey: keyForSerialNumber)
        aCoder.encode(dateCreated, forKey: keyForDateCreated)
        aCoder.encode(itemKey, forKey: keyForItemKey)
    }
    
    init(name: String, valueInDollars: Int, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = Int(arc4random_uniform(UInt32(adjectives.count)))
            let randomAdjective = adjectives[idx]
            
            idx = Int(arc4random_uniform(UInt32(adjectives.count)))
            let randomNoun = nouns[idx]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first
            self.init(name: randomName, valueInDollars: randomValue, serialNumber: randomSerialNumber)
            
        } else {
            self.init(name: "", valueInDollars: 0, serialNumber: nil)
        }
    }
}
