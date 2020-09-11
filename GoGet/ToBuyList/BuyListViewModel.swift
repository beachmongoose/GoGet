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
  func markAsBought(_ index: Int)
  func sortBy(_ element: String?)
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
    sortTypeInstance.changeSortType(to: SortType(rawValue: element!)!)
    fetchTableData()
  }
  
// MARK: - Change View
  func presentFullList() {
    coordinator.presentFullList(completion: {
      self.fetchTableData()
    })
  }
  
  func presentDetail(_ index: Int) {
    let item = getItems.fullItemInfo(for: index)
    coordinator.presentDetail(item, completion: {
      self.fetchTableData()
    })
  }
  
  func markAsBought(_ index: Int) {
    var allItems = getItems.load(orderBy: sortType)
    var currentItem = getItems.fullItemInfo(for: index)
    let itemIndex = getItems.indexNumber(for: currentItem, in: allItems)
    currentItem.bought = true
    currentItem.dateBought = Date()
    allItems[itemIndex] = currentItem
    getItems.save(allItems)
    fetchTableData()
  }
  
}
