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
  func presentDetail(for item: Item?)
  func editItem(at index: Int)
  func selectDeselectIndex(_ index: Int)
  func clearIndex()
  func removeItems()
  func sortBy(_ element: String?)
  func goingBack()
}

final class FullListViewModel: FullListViewModelType {

  struct CellViewModel {
    var name: String
    var quantity: String
    var buyData: String
    var isSelected: Bool

    init(item: Item) {
      self.name = item.name
      self.quantity = String(item.quantity)
      self.buyData = item.buyData
      self.isSelected = false
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
       completion: @escaping () -> Void) {
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
    let method = String((element?.components(separatedBy: " ")[0])!)
    sortTypeInstance.changeSortType(to: SortType(rawValue: method)!)
    fetchTableData()
  }

  func goingBack() {
    completion()
  }
}

// MARK: - Item Handling
extension FullListViewModel {

  func selectDeselectIndex(_ index: Int) {
    if selectedItems.contains(index) {
      selectedItems.remove(at: selectedItems.firstIndex(of: index)!)
      tableData[index].isSelected = false
    } else {
    selectedItems.append(index)
    tableData[index].isSelected = true
    }
  }

  func clearIndex() {
    selectedItems.removeAll()
    for item in 0..<tableData.count {
      tableData[item].isSelected = false
    }
  }

  func selectionToggle(_ index: Int, to bool: Bool) {
    tableData[index].isSelected = bool
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
      itemList.append(getItems.fullItemInfo(for: item, buyView: false))
    }
    for item in itemList {
      allItems.remove(at: getItems.indexNumber(for: item, in: allItems))
    }
    selectedItems.removeAll()
    getItems.save(allItems)
    fetchTableData()
  }
}
