//
//  ServiceObjects.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

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
  func fullItemInfo(for id: String) -> Item
  func fetchByCategory(_ view: ListView) -> [String: [Item]]
  func isDuplicate(_ name: String) -> Bool
}

class GetItems: GetItemsType {

  let sortTypeInstance: SortingInstanceType
  let categoryStore: CategoryStoreType
  let bag = DisposeBag()

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
        print("Error when loading Items. Failed to Load.")
      }

    switch sortType {
    case .name: finalItemData = byName(loadedItems)
    case .date: finalItemData = byDate(loadedItems)
    case .added: finalItemData = byAdded(loadedItems)
    }
    return (sortAscending == true) ? finalItemData : finalItemData.reversed()
  }

  func indexNumber(for item: String, in array: [Item]) -> Int {
    return array.firstIndex { $0.id == item } ?? 900
  }

  func fetchByCategory(_ view: ListView) -> [String: [Item]] {
    let data = load()
    let items = (view == .buyList) ? data.filter { $0.needToBuy } : data
    let categories = categoryStore.getDictionary()

    let tableData = items.reduce(into: [String: [Item]]()) { dict, item in
      var keyName = "Uncategorized"
      for category in categories where category.key == item.categoryID {
          keyName = category.value.name
      }
      dict[keyName, default: []].append(item)
    }
    return tableData
  }

  func fullItemInfo(for id: String) -> Item {
    let allItems = load()
    let index = indexNumber(for: id, in: allItems)
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
    let boughtItems = array.filter { $0.boughtStatus != .notBought}
    let unboughtItems = array.filter {$0.boughtStatus == .notBought}
    var sortedList = boughtItems.sorted(by: { $0.dateBought < $1.dateBought })
    for item in unboughtItems {
      sortedList.insert(item, at: 0)}
    return sortedList
  }

  func byAdded(_ array: [Item]) -> [Item] {
    return array.sorted(by: { $0.dateAdded ?? Date() < $1.dateAdded ?? Date()})
  }

  func removeDeletedCategoryID() {
    defaults.reactive.keyPath("Items", ofType: Data.self, context: .immediateOnMain).observeNext { _ in
      var items = self.load()
      let categories = self.categoryStore.getDictionary()
      var deletedID: String? {
        for item in items {
          guard item.categoryID != nil else { continue }
          let noKey = categories[item.categoryID!] == nil
          if noKey {
            return item.categoryID
          }
        }
        return nil
      }
      guard deletedID != nil else { return }
      for index in 0..<items.count where items[index].categoryID == deletedID {
        items[index].categoryID = nil
      }
      self.save(items)
    }
    .dispose(in: bag)
  }
}
