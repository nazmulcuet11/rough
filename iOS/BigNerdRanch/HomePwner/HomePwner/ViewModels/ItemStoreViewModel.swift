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
    
    private var allItems: [Section: [Item]] = [.regular: [Item](),
                                    .premium: [Item]()]
    
    var numberOfSection: Int {
        // Extra `1` for `No More Item` Section
        return Section.allCases.count + 1
    }
    
    func getTitleForHeader(in section: Int) -> String? {
        return Section(rawValue: section)?.toString
    }
    
    func numberOfRows(in sectionNumber: Int) -> Int {
        // `No more item` section
        guard let section = Section(rawValue: sectionNumber), let itemCount = allItems[section]?.count else {
            return 1
        }
        return itemCount
    }
    
    init() {
        /* If we need to populate item store with random items
         we can do so
        */
        for _ in 0..<5 {
            createItem()
        }
    }
    
    func getItem(using indexPath: IndexPath) -> Item? {
        guard let section = Section(rawValue: indexPath.section) else {
            return nil
        }
        
        guard let item = allItems[section]?[indexPath.row] else {
            return nil
        }
        
        return item
    }
    
    func getIndexPath(for item: Item) -> IndexPath? {
        for section in Section.allCases {
            if let index = allItems[section]?.lastIndex(of: item) {
                return IndexPath(row: index, section: section.rawValue)
            }
        }
        return nil
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        let itemType = newItem.valueInDollars <= 50 ? 0 : 1
        allItems[Section(rawValue: itemType)!]?.append(newItem)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        for section in Section.allCases {
            if let index = allItems[section]?.firstIndex(of: item) {
                allItems[section]?.remove(at: index)
                break
            }
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
        
        let fromIndex = fromIndexPath.row
        let toIndex = toIndexPath.row
        
        if let section = Section(rawValue: fromIndexPath.section), let movedItem = allItems[section]?[fromIndex] {
            allItems[section]?.remove(at: fromIndex)
            allItems[section]?.insert(movedItem, at: toIndex)
        }
    }
}
