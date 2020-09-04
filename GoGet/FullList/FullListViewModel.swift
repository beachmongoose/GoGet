//
//  FullListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

protocol FullListViewModelType {
  var tableData: [FullListViewModel.CellViewModel] { get }
  func presentDetail(item: Item?)
  func removeItem(at index: Int)
  func selectedItem(index: Int) -> Item
}

final class FullListViewModel: FullListViewModelType {
  
  func presentDetail(item: Item?) {
    coordinator.presentDetail(item: item)
  }
  
  var tableData = [CellViewModel]()
  var allItems = [Item]()
  
  struct CellViewModel {
    var name: String
    var buyData: String
  }
  
  private let coordinator: FullListCoordinatorType
  private let getItems: GetItemsType
  
  init(coordinator: FullListCoordinatorType, getItems: GetItemsType = GetItems())
  {
    self.coordinator = coordinator
    self.getItems = getItems
    fetchTableData()
  }
  
  func fetchTableData() {
      allItems = getItems.load()
      for item in allItems {
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
  
  func removeItem(at index: Int) {
    allItems.remove(at: index)
    getItems.save(allItems)
  }
  
  func selectedItem(index: Int) -> Item {
    let allItems = getItems.load()
    return allItems[index]
  }
  
  
}
