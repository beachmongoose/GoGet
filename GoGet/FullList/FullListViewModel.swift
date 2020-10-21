//
//  FullListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

protocol FullListViewModelType {
  var inDeleteMode: Property<Bool> { get }
  var tableData: MutableObservableArray2D<String, FullListViewModel.CellViewModel> { get }
  var tableCategories: [[FullListViewModel.CellViewModel]] { get }
  func changeEditing()
  func editItem(_ index: IndexPath)
  func selectDeselectIndex(at indexPath: IndexPath)
  func clearSelectedItems()
  func removeItems()
  func sortBy(_ element: String?)
}

final class FullListViewModel: FullListViewModelType {

  struct CellViewModel: Equatable {
    var name: String
    var id: String?
    var quantity: String
    var buyData: String
    var isSelected: Bool

    init(item: Item, isSelected: Bool) {
      self.name = item.name
      self.id = item.id
      self.quantity = String(item.quantity)
      self.buyData = item.buyData
      self.isSelected = isSelected
    }
  }
  var inDeleteMode = Property<Bool>(false)
  var dictionary: [String: [Item]] = [: ]
  var tableCategories = [[CellViewModel]]()
  let tableData = MutableObservableArray2D<String, FullListViewModel.CellViewModel>(Array2D(sections: []))
  private var selectedItems = MutableObservableArray<String>([])
  private let bag = DisposeBag()
  private let coordinator: FullListCoordinatorType
  private let getItems: GetItemsType
  private let getCategories: GetCategoriesType
  private let sortTypeInstance: SortingInstanceType
  private var sortType: SortType {
    sortTypeInstance.sortType
  }

  init(coordinator: FullListCoordinatorType,
       getItems: GetItemsType = GetItems(),
       getCategories: GetCategoriesType = GetCategories(),
       sortTypeInstance: SortingInstanceType = SortingInstance.shared
      ) {
    self.coordinator = coordinator
    self.getItems = getItems
    self.getCategories = getCategories
    self.sortTypeInstance = sortTypeInstance
    fetchArrayData()
    observeItemUpdates()
    observeSelectedItems()
  }

// MARK: - Organzing
  func reOrder(_ array: [(String, [CellViewModel])]) -> [(String, [CellViewModel])] {
    var data = array
    guard data.contains(where: {$0.0 == "Uncategorized"}) else { return data }
    let index = data.firstIndex(where: { $0.0 == "Uncategorized" })
    let uncategorized = data[index!]
    data.remove(at: index!)
    data.append(uncategorized)
    return data
  }

  func sortBy(_ element: String?) {
    let method = String((element?.components(separatedBy: " ")[0])!)
    sortTypeInstance.changeSortType(to: SortType(rawValue: method)!)
    fetchArrayData()
  }
}

// MARK: - Item Handling
extension FullListViewModel {

  func editItem(_ index: IndexPath) {
    let category = tableData.collection.sections[index.section].metadata
    let itemCategory = dictionary[category]
    guard let item = itemCategory?[index.row] else { fatalError("Unable to edit Item, out of range")}
    coordinator.presentDetail(item: item)
  }

  func changeEditing() {
    inDeleteMode.value.toggle()
  }

  func selectDeselectIndex(at indexPath: IndexPath) {
    let itemID = tableData.collection.sections[indexPath.section].items[indexPath.row].id
    var array = selectedItems.array
    if array.contains(itemID!) {
      array.remove(at: array.firstIndex(of: itemID!)!)
      selectedItems.replace(with: array)
    } else {
      selectedItems.append(itemID!)
    }
  }

  func removeItems() {
    var allItems = getItems.load()
    for id in selectedItems.array {
      let index = getItems.indexNumber(for: id, in: allItems)
      allItems.remove(at: index)
    }
    selectedItems.removeAll()
    getItems.save(allItems)
  }

  func clearSelectedItems() {
    selectedItems.removeAll()
  }
}

// MARK: - Datasource Helper
extension FullListViewModel {

  func fetchArrayData() {
    let data = createDictionary().map { ($0.key, $0.value) }.sorted(by: {$0.0 < $1.0 })
    let sortedData = reOrder(data)
    let sections = sortedData.map { entry in
      return Array2D.Section(metadata: entry.0, items: entry.1)
    }
    tableData.replace(with: Array2D(sections: sections))
  }

  func createDictionary() -> [String: [CellViewModel]] {
    dictionary = getItems.fetchByCategory(.fullList)
    let formattedDict: [String: [CellViewModel]] = dictionary.mapValues {
      $0.map { item in
        let isSelected = selectedItems.array.contains(item.id)
        return CellViewModel(item: item, isSelected: isSelected)
      }
    }
    return formattedDict
  }
}

// MARK: - Data Observation
extension FullListViewModel {
  func observeItemUpdates() {
    let defaults = UserDefaults.standard
    defaults.reactive.keyPath("Items", ofType: Data.self, context: .immediateOnMain).observeNext { _ in
      self.fetchArrayData()
    }
    .dispose(in: bag)
  }

  func observeSelectedItems() {
    selectedItems.observeNext { _ in
      self.fetchArrayData()
    }
    .dispose(in: bag)
  }
}
