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
  func presentDetail(for item: Item?)
  func editItem(_ index: IndexPath)
  func selectDeselectIndex(at indexPath: IndexPath)
  func clearIndex()
  func removeItems()
  func sortBy(_ element: String?)
  func clear()
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
  private var selectedItems = [String]()
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
  }

// MARK: - Organzing

  func observeItemUpdates() {
    let defaults = UserDefaults.standard
    defaults.reactive.keyPath("Items", ofType: Data.self, context: .immediateOnMain).observeNext { _ in
      self.fetchArrayData()
    }
    .dispose(in: bag)
  }

  func clear() {
    tableData.removeAll()
  }

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

  func selectDeselectIndex(at indexPath: IndexPath) {
    let itemID = tableData.collection.sections[indexPath.section].items[indexPath.row].id
    if selectedItems.contains(itemID!) {
      selectedItems.remove(at: selectedItems.firstIndex(of: itemID!)!)
      fetchArrayData()
    } else {
      selectedItems.append(itemID!)
      fetchArrayData()
    }
  }

  func changeEditing(){
    inDeleteMode.value.toggle()
  }

  func clearIndex() {
    selectedItems.removeAll()
    fetchArrayData()
  }

  func editItem(_ index: IndexPath) {
    let category = tableData.collection.sections[index.section].metadata
    let itemCategory = dictionary[category]
    let item = itemCategory?[index.row]
    presentDetail(for: item)
  }

  func presentDetail(for item: Item?) {
    coordinator.presentDetail(item: item)
  }

  func removeItems() {
    var allItems = getItems.load()
    for id in selectedItems {
      let index = getItems.indexNumber(for: id, in: allItems)
      allItems.remove(at: index)
    }
    selectedItems.removeAll()
    getItems.save(allItems)
  }
}

// MARK: - Datasource Helper
extension FullListViewModel {
  func createDictionary() -> [String: [CellViewModel]] {
    dictionary = getItems.fetchByCategory(.fullList)
    let formattedDict: [String: [CellViewModel]] = dictionary.mapValues {
      $0.map { item in
        let isSelected = selectedItems.contains(item.id)
        return CellViewModel(item: item, isSelected: isSelected)
      }
    }
    return formattedDict
  }

  func fetchArrayData() {
    let data = createDictionary().map { ($0.key, $0.value) }.sorted(by: {$0.0 < $1.0 })
    let sortedData = reOrder(data)
    let sections = sortedData.map { entry in
      return Array2D.Section(metadata: entry.0, items: entry.1)
    }
    tableData.replace(with: Array2D(sections: sections))
  }
}
