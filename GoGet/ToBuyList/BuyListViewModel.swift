//
//  BuyListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import UIKit

protocol BuyListViewModelType {
  var tableData: [BuyListViewModel.CellViewModel] { get }
  func presentFullList()
  func presentDetail(_ index: Int)
  func markAsBought()
  func sortBy(_ element: String?)
  func selectDeselectIndex(_ index: Int)
}

final class BuyListViewModel: BuyListViewModelType {
  var tableData = [CellViewModel]()

  struct CellViewModel {
    var name: String
    var quantity: String
    var buyData: String

    init(item: Item) {
      self.name = item.name
      self.quantity = String(item.quantity)
      self.buyData = item.buyData
    }
  }

  private var itemIndexes: [Int] = []
  private let coordinator: BuyListCoordinatorType
  private let getItems: GetItemsType
  private let sortTypeInstance: SortingInstanceType
  private var sortType: SortType {
  sortTypeInstance.sortType
  }

  init(
    coordinator: BuyListCoordinatorType,
    getItems: GetItemsType = GetItems(),
    sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
    self.coordinator = coordinator
    self.getItems = getItems
    self.sortTypeInstance = sortTypeInstance
    fetchTableData()
  }

// MARK: - Organizing
  func fetchTableData() {
    let toBuyItems = getItems.load(orderBy: sortType).filter { $0.needToBuy }
    tableData = toBuyItems.map(CellViewModel.init(item:))
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

  func presentDetail(_ index: Int) {
    let item = getItems.fullItemInfo(for: index, buyView: true)
    coordinator.presentDetail(item, completion: {
      self.fetchTableData()
    })
  }

  func selectDeselectIndex(_ index: Int) {
    itemIndexes.append(index)
  }

  func markAsBought() {
    var allItems = getItems.load(orderBy: sortType)
    for index in itemIndexes {
      var currentItem = getItems.fullItemInfo(for: index, buyView: true)
    let itemIndex = getItems.indexNumber(for: currentItem, in: allItems)
    currentItem.bought = true
    currentItem.dateBought = Date()
    allItems[itemIndex] = currentItem
    }
    getItems.save(allItems)
    fetchTableData()
  }

}
