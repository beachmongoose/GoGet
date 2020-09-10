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
  func goingBack()
}

final class FullListViewModel: FullListViewModelType {
  
  func presentDetail(item: Item?) {
    coordinator.presentDetail(item: item, completion: {
      self.fetchTableData()
    })
  }
  
  var tableData = [CellViewModel]()
  var allItems = [Item]()
  
  struct CellViewModel {
    var name: String
    var buyData: String
    
    init(item: Item) {
      self.name = item.name
      self.buyData = item.buyData
    }
  }
  
  private let coordinator: FullListCoordinatorType
  private let getItems: GetItemsType
  var completion: () -> Void
  
  init(coordinator: FullListCoordinatorType, getItems: GetItemsType = GetItems(), completion: @escaping () -> Void)
  {
    self.coordinator = coordinator
    self.getItems = getItems
    self.completion = completion
    fetchTableData()
  }
  
  func fetchTableData() {
      allItems = getItems.load()
      tableData = allItems.map(CellViewModel.init(item:))
  }
  
  func removeItem(at index: Int) {
    allItems.remove(at: index)
    getItems.save(allItems)
    fetchTableData()
  }
  
  func selectedItem(index: Int) -> Item {
    let allItems = getItems.load()
    return allItems[index]
  }
  func goingBack() {
    completion()
  }
}
