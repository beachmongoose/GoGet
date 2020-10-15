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
  var tableData: MutableObservableArray2D<String, BuyListViewModel.CellViewModel> { get }
  func presentFullList()
  func presentDetail(in section: Int, for row: Int)
  func markAsBought()
  func sortBy(_ element: String?)
  func selectDeselectIndex(_ index: IndexPath)
}

final class BuyListViewModel: BuyListViewModelType {

  struct CellViewModel {
    var name: String
    var quantity: String
    var buyData: String
    var isSelected: Bool

    init(item: Item, isSelected: Bool) {
      self.name = item.name
      self.quantity = String(item.quantity)
      self.buyData = item.buyData
      self.isSelected = isSelected
    }
  }

  let tableData = MutableObservableArray2D<String, BuyListViewModel.CellViewModel>(Array2D(sections: []))
  private var itemIndexes: [IndexPath] = []
  private var selectedItems = (Set<String>())
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
    fetchTableData()
  }

// MARK: - Fetch Data
  func fetchTableData() {
    let data = createDictionary().map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 })
    let sortedData = reOrder(data)
    let sections = sortedData.map { entry in
      return Array2D.Section(metadata: entry.0, items: entry.1)
    }
    tableData.replace(with: Array2D(sections: sections))
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

  func createDictionary() -> [String: [CellViewModel]] {
    let dictionary = getItems.fetchByCategory(.buyList)
    let formattedDict: [String: [CellViewModel]] = dictionary.mapValues {
      $0.map { item in
        let isSelected = selectedItems.contains(item.name)
        return CellViewModel(item: item, isSelected: isSelected)
      }
    }
    return formattedDict
  }

  func sortBy(_ element: String?) {
    let method = String((element?.components(separatedBy: " ")[0])!)
    sortTypeInstance.changeSortType(to: SortType(rawValue: method)!)
    fetchTableData()
  }

// MARK: - Change View
  func presentFullList() {
    coordinator.presentFullList(completion: {
      self.fetchTableData()
    })
  }

  func presentDetail(in section: Int, for row: Int) {
    let data = tableData.collection.sections[section].items[row]
    let item = getItems.fullItemInfo(for: data.name)
    coordinator.presentDetail(item, completion: {
      self.fetchTableData()
    })
  }

  func selectDeselectIndex(_ index: IndexPath) {
    itemIndexes.append(index)
  }

  func markAsBought() {
    var allItems = getItems.load()
    for item in selectedItems {
      var currentItem = getItems.fullItemInfo(for: item)
      let itemIndex = getItems.indexNumber(for: currentItem.id, in: allItems)
      currentItem.boughtStatus = .bought(Date())
      allItems[itemIndex] = currentItem
    }
    getItems.save(allItems)
    fetchTableData()
  }

}
