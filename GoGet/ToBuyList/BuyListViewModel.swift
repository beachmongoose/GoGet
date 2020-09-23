//
//  BuyListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import UIKit

protocol BuyListViewModelType {
  var tableData: [(String, [BuyListViewModel.CellViewModel])] { get }
  func presentFullList()
  func presentDetail(for index: Int, in section: Int)
  func markAsBought()
  func sortBy(_ element: String?)
  func selectDeselectIndex(_ index: Int)
}

final class BuyListViewModel: BuyListViewModelType {
  var tableData = [(String, [CellViewModel])]()

  struct CellViewModel {
    var name: String
    var quantity: String
    var buyData: String

    init(item: Item, isSelected: Bool) {
      self.name = item.name
      self.quantity = String(item.quantity)
      self.buyData = item.buyData
    }
  }

  private var itemIndexes: [Int] = []
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
    let data = createDictionary()
    tableData = data.map { ($0.key, $0.value) }
  }

  func createDictionary() -> [String: [CellViewModel]] {
    let dictionary = getItems.fetchByCategory("buy")
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

  func presentDetail(for index: Int, in section: Int) {
    let data = tableData[section].1[index]
    let item = getItems.fullItemInfo(for: data.name)
    coordinator.presentDetail(item, completion: {
      self.fetchTableData()
    })
  }

  func selectDeselectIndex(_ index: Int) {
    itemIndexes.append(index)
  }

  func markAsBought() {
    var allItems = getItems.load()
    for item in selectedItems {
      var currentItem = getItems.fullItemInfo(for: item)
      let itemIndex = getItems.indexNumber(for: currentItem.name, in: allItems)
      currentItem.bought = true
      currentItem.dateBought = Date()
      allItems[itemIndex] = currentItem
    }
    getItems.save(allItems)
    fetchTableData()
  }

}
