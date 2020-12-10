//
//  ServiceObjects.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import PromiseKit
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
    var items: MutableObservableArray<Item> { get }
    func indexNumber(for item: String, in array: [Item]) -> Int
    func fetchByCategory(_ view: ListView) -> [String: [Item]]
    func isDuplicate(_ name: String) -> Bool
    func update(_ item: Item) -> Promise<Void>
    func upSert(_ item: Item) -> Promise<Void>
}

class GetItems: GetItemsType {
    public enum Errors: Error {
        case itemNotFound
    }
    let sortTypeInstance: SortingInstanceType
    let categoryStore: CategoryStoreType
    let bag = DisposeBag()
    var items = MutableObservableArray<Item>([])

    init(sortTypeInstance: SortingInstanceType = SortingInstance.shared,
         categoryStore: CategoryStoreType = CategoryStore.shared) {
        self.sortTypeInstance = sortTypeInstance
        self.categoryStore = categoryStore
        load()
        observeItemsUpdates()
//        removeDeletedCategoryID()
  }

// MARK: - Data Handling
    func save(_ items: [Item]) {
        guard let persistenceData = items.persistenceData else { print("Error")
        return
    }
    saveData(persistenceData)
  }

    func load() {
        let sortType = sortTypeInstance.sortType
        let sortAscending = sortTypeInstance.sortAscending
        var loadedItems = [Item]()
        var finalItemData = [Item]()
        let data = loadData(for: "Items")
        guard data != nil else { return }

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
        items.replace(with: (sortAscending == true) ? finalItemData : finalItemData.reversed())
    }

    func indexNumber(for item: String, in array: [Item]) -> Int {
        guard let index = (array.firstIndex { $0.id == item }) else { fatalError("Item index not found")}
        return index
    }

    func fetchByCategory(_ view: ListView) -> [String: [Item]] {
        let data = items.array
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

    func isDuplicate(_ name: String) -> Bool {
        return (items.array.map {$0.name.lowercased() == name.lowercased()}).contains(true)
    }

// MARK: - Saving

    func update(_ item: Item) -> Promise<Void> {
        Promise<Void> { seal in
            firstly {
                loadPromise()
            }.then { array in
                self.replaceItem(in: array, with: item)
            }.then { allItems in
                self.savePromise(allItems)
            }.done {
                seal.fulfill(())
            }.catch { _ in
                fatalError("Item not found")
            }
        }
  }

    func upSert(_ item: Item) -> Promise<Void> {
        Promise<Void> { seal in
            firstly {
                loadPromise()
            }.then { array in
                self.appendItem(item, to: array)
            }.then { allItems in
                self.savePromise(allItems)
            }.done {
                seal.fulfill(())
            }.catch { _ in
                fatalError("Unable to save Item")
            }
        }
    }

    func loadPromise() -> Promise<[Item]> {
        return Promise<[Item]> { seal in
            let array = items.array
            seal.fulfill(array)
        }
    }

    func appendItem(_ item: Item, to array: [Item]) -> Promise<[Item]> {
        return Promise<[Item]> { seal in
            var allItems = array
            allItems.append(item)
            seal.fulfill(allItems)
        }
    }

    func replaceItem(in array: [Item], with item: Item) -> Promise<[Item]> {
        return Promise<[Item]> {seal in
        let index = indexNumber(for: item.id, in: array)
        var allItems = array
        allItems[index] = item
        seal.fulfill(allItems)
        }
    }

    func savePromise(_ items: [Item]) -> Promise<Void> {
        Promise<Void> { seal in
            guard let persistenceData = items.persistenceData else { print("Error")
                return }
            saveData(persistenceData)
            seal.fulfill(())
        }
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

    func observeItemsUpdates() {
        let defaults = UserDefaults.standard
        defaults.reactive.keyPath("Items", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { [weak self] _ in
            self?.load()
        }
        .dispose(in: bag)
    }
    }

//    func removeDeletedCategoryID() {
//        defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
//            let categories = self.categoryStore.getDictionary()
//            var deletedID: String? {
//                for item in self.items {
//                    guard item.categoryID != nil else { continue }
//                    let noKey = categories[item.categoryID!] == nil
//                    if noKey {
//                        return item.categoryID
//                    }
//                }
//                return nil
//            }
//            guard deletedID != nil else { return }
//            for index in 0..<self.items.count where self.items[index].categoryID == deletedID {
//                self.items[index].categoryID = nil
//            }
//            self.save(self.items)
//        }
//        .dispose(in: bag)
//    }
//}
