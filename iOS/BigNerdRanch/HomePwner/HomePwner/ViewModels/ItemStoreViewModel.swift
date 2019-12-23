//
//  ItemStore.swift
//  HomePwner
//
//  Created by Nazmul Islam on 9/3/19.
//  Copyright © 2019 Nazmul Islam. All rights reserved.
//

import UIKit

class ItemStoreViewModel {
    private enum Section: Int {
        case regular = 0, premium
        
        static var allCases: [Section] = [.regular, .premium]
        var toString: String {
            switch self {
            case .regular:
                return "Regular"
            case .premium:
                return "Premium"
            }
        }
    }
    
    private var allItems: [Item] = [Item]()
    private var itemsInSection: [Section: [Item]] {
        return [.regular: allItems.filter({ $0.valueInDollars <= 50 }),
                .premium: allItems.filter({ $0.valueInDollars > 50 })]
    }
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.archive")
    }()
    
    var numberOfSection: Int {
        // Extra `1` for `No More Item` Section
        return Section.allCases.count + 1
    }
    
    func getTitleForHeader(in section: Int) -> String? {
        return Section(rawValue: section)?.toString
    }
    
    func numberOfRows(in sectionNumber: Int) -> Int {
        // `No more item` section
        guard let section = Section(rawValue: sectionNumber), let itemCount = itemsInSection[section]?.count else {
            return 1
        }
        return itemCount
    }
    
    init() {
        /* If we need to populate item store with random items
         we can do so
        */
//        for _ in 0..<5 {
//            createItem()
//        }
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            if let archivedItems = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Item] {
                allItems = archivedItems
            }
        } catch {
            print("Could not load items.")
        }
    }
    
    func getItem(using indexPath: IndexPath) -> Item? {
        guard let section = Section(rawValue: indexPath.section) else {
            return nil
        }
        
        guard let item = itemsInSection[section]?[indexPath.row] else {
            return nil
        }
        
        return item
    }
    
    func getIndexPath(for item: Item) -> IndexPath? {
        for section in Section.allCases {
            if let index = itemsInSection[section]?.lastIndex(of: item) {
                return IndexPath(row: index, section: section.rawValue)
            }
        }
        return nil
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func canMoveItem(from fromIndexPath: IndexPath, to toIndexPath: IndexPath) -> Bool {
        if fromIndexPath.section > 1 || toIndexPath.section > 1 {
            return false
        }
        
        if fromIndexPath.section != toIndexPath.section {
            return false
        }
        
        return true
    }
    
    func moveItem(from fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
        guard canMoveItem(from: fromIndexPath, to: toIndexPath) else {
            return
        }
        
        // Lot's of tricks :'(
        let fromIndex = fromIndexPath.row
        let toIndex = toIndexPath.row
        
        var regularItems = itemsInSection[.regular]
        var premiumItems = itemsInSection[.premium]
        
        if let section = Section(rawValue: fromIndexPath.section),
            let movedItem = itemsInSection[section]?[fromIndex] {
            
            switch section {
            case .regular:
                regularItems?.remove(at: fromIndex)
                regularItems?.insert(movedItem, at: toIndex)
            case .premium:
                premiumItems?.remove(at: fromIndex)
                premiumItems?.insert(movedItem, at: toIndex)
            }
            
            allItems.removeAll()
            if let __regularItems = regularItems {
                allItems.append(contentsOf: __regularItems)
            }
            if let __premiumItems = premiumItems {
                allItems.append(contentsOf: __premiumItems)
            }
        }
    }
    
    func saveChanges() {
        print("Saving items to: \(itemArchiveURL.path)")
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: allItems, requiringSecureCoding: false)
            try data.write(to: itemArchiveURL)
            print("Successfully saved all of the items!!")
        } catch {
            print("Could not save any of the items!!")
        }
    }
}
