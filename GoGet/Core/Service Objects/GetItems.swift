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
  func load(orderBy: SortType) -> [Item]
  func indexNumber(for item: Item, in array: [Item]) -> Int
  func fullItemInfo(for index: Int, buyView isBuyView: Bool) -> Item
  func fetchByCategory() -> [String: [Item]]
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

  func load(orderBy: SortType) -> [Item] {
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

    switch orderBy {
    case .name: finalItemData = byName(loadedItems)
    case .date: finalItemData = byDate(loadedItems)
    case .added: finalItemData = byAdded(loadedItems)
    }
    return (sortAscending == true) ? finalItemData : finalItemData.reversed()
  }

  func indexNumber(for item: Item, in array: [Item]) -> Int {
    return array.firstIndex { $0.name == item.name &&
                              $0.quantity == item.quantity &&
                              $0.dateBought == item.dateBought &&
                              $0.duration == item.duration &&
                              $0.bought == item.bought
                            } ?? 900
  }

  func fetchByCategory() -> [String: [Item]] {
    let items = load(orderBy: sortTypeInstance.sortType)
    var tableFormat = [String: [Item]]()

    let tableData = items.reduce(into: [String: [Item]]()) { dict, item in
      if let itemID = item.categoryID {
        dict[itemID]!.append(item)
      } else {
        tableFormat["Uncategorized", default: []].append(item)
      }
    }
    return tableData
  }

// MARK: - For Buy List
  func fullItemInfo(for index: Int, buyView isBuyView: Bool) -> Item {
    let allItems = load(orderBy: sortTypeInstance.sortType)
    let selectedItem = isBuyView ? allItems.filter { $0.needToBuy } [index] : allItems[index]
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
