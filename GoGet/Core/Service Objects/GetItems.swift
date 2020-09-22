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

enum ListView: String {
  case buyList
  case fullList
}

protocol GetItemsType {
  func save(_ items: [Item])
  func load() -> [Item]
  func indexNumber(for item: String, in array: [Item]) -> Int
  func fullItemInfo(for name: String) -> Item
  func fetchByCategory(_ view: String) -> [String: [Item]]
  func isDuplicate(_ name: String) -> Bool
}

class GetItems: GetItemsType {

  let sortTypeInstance: SortingInstanceType
  let categoryStore: CategoryStoreType

  init(sortTypeInstance: SortingInstanceType = SortingInstance.shared,
       categoryStore: CategoryStoreType = CategoryStore.shared) {
    self.sortTypeInstance = sortTypeInstance
    self.categoryStore = categoryStore
  }

  func save(_ items: [Item]) {
    guard let persistenceData = items.persistenceData else { print("Error")
      return
    }
    saveData(persistenceData)
  }

  func load() -> [Item] {
    let sortType = sortTypeInstance.sortType
    let sortAscending = sortTypeInstance.sortAscending
    var loadedItems = [Item]()
    var finalItemData = [Item]()
    let data = loadData(for: "Items")
    guard data != nil else { return [] }

      do {
        let item = try jsonDecoder.decode([Item].self, from: data!)
        loadedItems = item
      } catch {
        print("Failed to Load")
      }

    switch sortType {
    case .name: finalItemData = byName(loadedItems)
    case .date: finalItemData = byDate(loadedItems)
    case .added: finalItemData = byAdded(loadedItems)
    }
    return (sortAscending == true) ? finalItemData : finalItemData.reversed()
  }

  func indexNumber(for item: String, in array: [Item]) -> Int {
    return array.firstIndex { $0.name.lowercased() == item
                            } ?? 900
  }

  func fetchByCategory(_ view: String) -> [String: [Item]] {
    let data = load()
    let items = (view == "buy") ? data.filter { $0.needToBuy } : data
    let tableData = items.reduce(into: [String: [Item]]()) { dict, item in
      let categoryID = item.categoryID
      if item.categoryID == nil {
        dict["", default: []].append(item)
      } else {
        dict[categoryID!, default: []].append(item)
      }
    }
    return tableData
  }

  func fullItemInfo(for name: String) -> Item {
    let allItems = load()
    let index = indexNumber(for: name, in: allItems)
    return allItems[index]
  }

  func isDuplicate(_ name: String) -> Bool {
    let items = load()
    return (items.map {$0.name.lowercased() == name.lowercased()}).contains(true)
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
