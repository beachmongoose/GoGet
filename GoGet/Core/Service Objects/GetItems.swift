//
//  ServiceObjects.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

enum SortType: String {
  case name
  case date
  case added
}

protocol GetItemsType {
  func save(_ items: [Item])
  func load(orderBy: SortType) -> [Item]
  func indexNumber(for item: Item, in array: [Item]) -> Int
  func fullItemInfo(for index: Int) -> Item
}

class GetItems: GetItemsType {

  func save(_ items: [Item]) {
    let json = JSONEncoder()
    if let savedData = try? json.encode(items) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "Items")
    } else {
      print("Failed to save")
    }
  }
  
  func load(orderBy: SortType) -> [Item] {
    var loadedItems = [Item]()
    let defaults = UserDefaults.standard
    if let itemsData = defaults.object(forKey: "Items") as? Data {
      let json = JSONDecoder()
      
      do {
        let item = try json.decode([Item].self, from: itemsData)
        loadedItems = item
      } catch {
        print("Failed to Load")
      }
    }
    switch orderBy {
    case .name: return byName(loadedItems)
    case .date: return byDate(loadedItems)
    case .added: return byAdded(loadedItems)
    }
  }
  
  func indexNumber(for item: Item, in array: [Item]) -> Int {
    return array.firstIndex { $0.name == item.name &&
                              $0.quantity == item.quantity &&
                              $0.dateBought == item.dateBought &&
                              $0.duration == item.duration &&
                              $0.bought == item.bought
                            } ?? 0
  }

// MARK: - For Buy List
  func fullItemInfo(for index: Int) -> Item {
    let allItems = load(orderBy: .added)
    let selectedItem = allItems.filter { $0.needToBuy} [index]
    let originalIndex = indexNumber(for: selectedItem, in: allItems)
    return allItems[originalIndex]
  }

// MARK: - Sorting
  func byName(_ array: [Item]) -> [Item] {
    return array.sorted(by: { $0.name < $1.name })
  }

  func byDate(_ array: [Item]) -> [Item] {
    let boughtItems = array.filter { $0.bought }
    let unboughtItems = array.filter {!$0.bought}
    var sortedList = boughtItems.sorted(by: { $0.dateBought < $1.dateBought})
    for item in unboughtItems {
      sortedList.insert(item, at: 0)}
    return sortedList
  }
  
  func byAdded(_ array: [Item]) -> [Item] {
    return array.sorted(by: { $0.dateAdded < $1.dateAdded})
  }
  
}
