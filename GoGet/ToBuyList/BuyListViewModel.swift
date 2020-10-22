//
//  BuyListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol BuyListViewModelType {
  var tableData: MutableObservableArray2D<String, BuyListCellViewModel> { get }
  func presentDetail(in section: Int, for row: Int)
  func markAsBought()
  func sortBy(_ element: String?)
  func selectDeselectIndex(_ index: IndexPath)
}

final class BuyListViewModel: BuyListViewModelType {
  var dictionary: [String: [Item]] = [: ]
  let bag = DisposeBag()
  let tableData = MutableObservableArray2D<String, BuyListCellViewModel>(Array2D(sections: []))
  private var selectedItems = Property<Set<String>>(Set())
  private let coordinator: BuyListCoordinatorType
  private let getItems: GetItemsType
  private let getCategories: GetCategoriesType
  private let sortTypeInstance: SortingInstanceType
  private var sortType: SortType {
  sortTypeInstance.sortType
  }

  init(
    coordinator: BuyListCoordinatorType,
    getItems: GetItemsType = GetItems(),
    getCategories: GetCategoriesType = GetCategories(),
    sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
    self.coordinator = coordinator
    self.getItems = getItems
    self.getCategories = getCategories
    self.sortTypeInstance = sortTypeInstance
    observeItemUpdates()
    observeSelectedItems()
  }
}

// MARK: - Datasource Helper
extension BuyListViewModel {

  func fetchTableData() {
    let data = createDictionary().map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 })
    let sortedData = reOrder(data)
    let sections = sortedData.map { entry in
      return Array2D.Section(metadata: entry.0, items: entry.1)
    }
    tableData.replace(with: Array2D(sections: sections))
  }

  func createDictionary() -> [String: [BuyListCellViewModel]] {
    dictionary = getItems.fetchByCategory(.buyList)
    let formattedDict: [String: [BuyListCellViewModel]] = dictionary.mapValues {
      $0.map { item in
        let isSelected = selectedItems.value.contains(item.id)
        return BuyListCellViewModel(item: item, isSelected: isSelected)
      }
    }
    return formattedDict
  }

// MARK: - Organizing
  func reOrder(_ array: [(String, [BuyListCellViewModel])]) -> [(String, [BuyListCellViewModel])] {
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
    fetchTableData()
  }

// MARK: - Item Handling

  func presentDetail(in section: Int, for row: Int) {
    let category = tableData.collection.sections[section].metadata
    let itemCategory = dictionary[category]
    guard let item = itemCategory?[row] else { fatalError("Unable to edit item, out fo range.")}
    coordinator.presentDetail(item)
  }

  func selectDeselectIndex(_ index: IndexPath) {
    let itemID = tableData.collection.sections[index.section].items[index.row].id
    if selectedItems.value.contains(itemID) {
      selectedItems.value.remove(itemID)
    } else {
      selectedItems.value.insert(itemID)
    }
  }

  func markAsBought() {
    var allItems = getItems.load()
    for id in selectedItems.value {
      let index = getItems.indexNumber(for: id, in: allItems)
      var item = allItems[index]
      item.boughtStatus = .bought(Date())
      allItems[index] = item
    }
    selectedItems.value = (Set())
    getItems.save(allItems)

  }

}
// MARK: - Data Observation
extension BuyListViewModel {
  func observeItemUpdates() {
    let defaults = UserDefaults.standard
    defaults.reactive.keyPath("Items", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
      self.fetchTableData()
    }
    .dispose(in: bag)
  }

  func observeSelectedItems() {
    selectedItems.observeNext { [weak self] _ in
      self?.fetchTableData()
    }
    .dispose(in: bag)

  }
}
