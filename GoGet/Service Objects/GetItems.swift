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
}
