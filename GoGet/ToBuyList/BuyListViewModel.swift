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
}

final class BuyListViewModel: BuyListViewModelType {
  var tableData = [CellViewModel]()
  
  struct CellViewModel {
    var name: String
    var buyData: String
    
    init(item: Item) {
      self.name = item.name
      self.buyData = item.buyData
    }
  }
  
  private let coordinator: BuyListCoordinatorType
  private let getItems: GetItemsType

  init(coordinator: BuyListCoordinatorType, getItems: GetItemsType = GetItems()) {
    self.coordinator = coordinator
    self.getItems = getItems
    fetchTableData()
  }
  
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
  
  func fetchTableData() {
    let toBuyItems = getItems.load().filter { $0.needToBuy }
    tableData = toBuyItems.map(CellViewModel.init(item:))
  }
  
  func markAsBought(_ index: Int) {
    var allItems = getItems.load()
    var currentItem = getItems.fullItemInfo(for: index)
    let itemIndex = getItems.indexNumber(for: currentItem, in: allItems)
    currentItem.bought = true
    currentItem.dateBought = Date()
    allItems[itemIndex] = currentItem
    getItems.save(allItems)
    fetchTableData()
  }
  
}
