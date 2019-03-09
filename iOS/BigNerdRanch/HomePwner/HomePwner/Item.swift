//
//  Items.swift
//  HomePwner
//
//  Created by Nazmul Islam on 8/3/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    
    init(name: String, valueInDollars: Int, serialNumber: String?) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        
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
