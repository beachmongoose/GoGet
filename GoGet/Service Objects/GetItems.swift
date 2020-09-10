//
//  ServiceObjects.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

protocol GetItemsType {
  func save(_ items: [Item])
  func load() -> [Item]
  func indexNumber(for item: Item, in array: [Item]) -> Int
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
  
  func load() -> [Item] {
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
    return loadedItems
  }
  
  func indexNumber(for item: Item, in array: [Item]) -> Int {
    return array.firstIndex { $0.name == item.name &&
                              $0.quantity == item.quantity &&
                              $0.dateBought == item.dateBought &&
                              $0.duration == item.duration &&
                              $0.bought == item.bought
                            } ?? 0
  }
}
