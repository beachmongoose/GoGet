//
//  FullListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import UIKit

protocol FullListViewModelType {
  var tableData: [(String, [FullListViewModel.CellViewModel])] { get }
  var tableCategories: [[FullListViewModel.CellViewModel]] { get }
  func presentDetail(for item: Item?)
  func editItem(in section: Int, at row: Int)
  func selectDeselectIndex(in section: Int, at row: Int)
  func clearIndex()
  func removeItems()
  func sortBy(_ element: String?)
  func goingBack()
}

final class FullListViewModel: FullListViewModelType {

  struct CellViewModel: Equatable {
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

  var tableCategories = [[CellViewModel]]()

  var tableData = [(String, [CellViewModel])]()
  private var selectedItems = (Set<String>())

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
    fetchTableData()
  }

// MARK: - Organzing

  func createDictionary() -> [String: [CellViewModel]] {
    let dictionary = getItems.fetchByCategory("full")
    let formattedDict: [String: [CellViewModel]] = dictionary.mapValues {
      $0.map { item in
        let isSelected = selectedItems.contains(item.name)
        return CellViewModel(item: item, isSelected: isSelected)
      }
    }
    return formattedDict
  }

  func fetchTableData() {
    tableData.removeAll()
    var data = createDictionary().map { ($0.key, $0.value) }.sorted(by: { $0.0 < $1.0 })
    if data.contains(where: {$0.0 == "Uncategorized"}) {
      let index = data.firstIndex(where: { $0.0 == "Uncategorized" })
      let uncategorized = data[index!]
      data.remove(at: index!)
      data.append(uncategorized)
    }
    tableData = data
  }

  func sortBy(_ element: String?) {
    let method = String((element?.components(separatedBy: " ")[0])!)
    sortTypeInstance.changeSortType(to: SortType(rawValue: method)!)
    fetchTableData()
  }

  func getItemInfo(in section: Int, for row: Int) -> Item {
    let item = tableData[section].1[row]
    return getItems.fullItemInfo(for: item.name.lowercased())
  }

  func goingBack() {
//    completion()
  }
}

// MARK: - Item Handling
extension FullListViewModel {

  func selectDeselectIndex(in section: Int, at row: Int) {
    let name = tableData[section].1[row].name.lowercased()
    if selectedItems.contains(name) {
      selectedItems.remove(at: selectedItems.firstIndex(of: name)!)
    } else {
    selectedItems.insert(name)
    fetchTableData()
    }
  }

  func clearIndex() {
    selectedItems.removeAll()
  }

  func deselect() {
  }

  func editItem(in section: Int, at row: Int) {
    let item = tableData[section].1[row].name.lowercased()
    let details = getItems.fullItemInfo(for: item)
    presentDetail(for: details)
  }

  func presentDetail(for item: Item?) {
    coordinator.presentDetail(item: item, completion: {
      self.fetchTableData()
    })
  }

  func removeItems() {
    var allItems = getItems.load()
    for item in selectedItems {
      guard !item.isEmpty else { continue }
      let index = getItems.indexNumber(for: item, in: allItems)
      allItems.remove(at: index)
    }
    selectedItems.removeAll()
    getItems.save(allItems)
    fetchTableData()
  }
}
