//
//  FullListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import UIKit

protocol FullListViewModelType {
  var tableData: [FullListViewModel.CellViewModel] { get }
  func editItem(at index: Int)
  func presentDetail(for item: Item?)
  func selectDeselectIndex(_ index: Int?)
  func removeItems()
  func sortBy(_ element: String?)
  func goingBack()
}

final class FullListViewModel: FullListViewModelType {
  
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
  
  var tableData = [CellViewModel]()
  var allItems = [Item]()
  private var selectedItems: [Int] = []
  
  private let coordinator: FullListCoordinatorType
  private let getItems: GetItemsType
  private let sortTypeInstance: SortingInstanceType
  var completion: () -> Void
  private var sortType: SortType {
    sortTypeInstance.sortType
  }
  
  init(coordinator: FullListCoordinatorType,
       getItems: GetItemsType = GetItems(),
       sortTypeInstance: SortingInstanceType = SortingInstance.shared,
       completion: @escaping () -> Void)
  {
    self.coordinator = coordinator
    self.getItems = getItems
    self.sortTypeInstance = sortTypeInstance
    self.completion = completion
    fetchTableData()
  }

// MARK: - Organzing
  func fetchTableData() {
    allItems = getItems.load(orderBy: sortType)
    tableData = allItems.map(CellViewModel.init(item:))
  }
  
  func sortBy(_ element: String?) {
    sortTypeInstance.changeSortType(to: SortType(rawValue: element!)!)
    fetchTableData()
  }
  
  func goingBack() {
    completion()
  }
}

// MARK: - Item Handling
extension FullListViewModel {
  
  func selectDeselectIndex(_ index: Int?) {
    guard index != nil else { selectedItems.removeAll()
      return
    }
    if let item = selectedItems.firstIndex(of: index!) {
      selectedItems.remove(at: item)
    } else {
    selectedItems.append(index!)
    }
  }
  
  func editItem(at index: Int) {
    let item = allItems[index]
    presentDetail(for: item)
  }
  
  func presentDetail(for item: Item?) {
    coordinator.presentDetail(item: item, completion: {
      self.fetchTableData()
    })
  }
  
  func removeItems() {
    var itemList: [Item] = []
    for item in selectedItems {
      itemList.append(getItems.fullItemInfo(for: item))
    }
    for item in itemList {
      allItems.remove(at: getItems.indexNumber(for: item, in: allItems))
    }
    selectedItems.removeAll()
    getItems.save(allItems)
    fetchTableData()
  }
}
