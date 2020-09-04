//
//  BuyListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

protocol BuyListViewModelType {
  var tableData: [BuyListViewModel.CellViewModel] { get }
  func presentFullList()
}

final class BuyListViewModel: BuyListViewModelType {
  var tableData = [CellViewModel]()
  
  struct CellViewModel {
    var name: String
    var buyData: String
    
  }
  
  private let coordinator: BuyListCoordinatorType
  private let getItems: GetItemsType

  init(coordinator: BuyListCoordinatorType, getItems: GetItemsType = GetItems()) {
    self.coordinator = coordinator
    self.getItems = getItems
    fetchTableData()
  }
  
  func presentFullList() {
    coordinator.presentFullList()
  }
  func fetchTableData() {
    var toBuyItems = [Item]()
      let allItems = getItems.load()
      for item in allItems {
        if item.needToBuy {
          toBuyItems.append(item)
        }
      }
    for item in toBuyItems {
      tableData.append(CellViewModel(name: item.name, buyData: buyData(for: item)))
    }
  }
  
  func buyData(for item: Item) -> String {
    if item.bought != true {
      return "Not bought"
    }
    if item.timeSinceBuying > 1 || item.timeSinceBuying == 0 {
      return "\(item.timeSinceBuying) days ago"
    } else {
      return "1 day ago"
    }
  }
}