//
//  CategoryListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/30/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

typealias CategoryCell = CategoryViewModel.CellViewModel

protocol CategoryListViewModelType {
  var tableData: MutableObservableArray<CategoryCell> { get }
  func isDuplicate(_ input: String) -> Bool
  func changeSelectedIndex(to index: Int)
}

final class CategoryViewModel: CategoryListViewModelType {
  struct CellViewModel {
    var name: String
    init(category: Category) {
      self.name = category.name
    }
  }

  var tableData = MutableObservableArray<CategoryCell>([])
  private var categories: [Category]
  var selectedIndex: Property<Int?>
  private let coordinator: CategoryViewCoordinatorType

  init(coordinator: CategoryViewCoordinatorType, selectedIndex: Property<Int?>, categories: [Category]) {
    self.coordinator = coordinator
    self.selectedIndex = selectedIndex
    self.categories = categories
    fetchTableData()
  }
}

extension CategoryViewModel {

  func fetchTableData() {
//    let createNew = CellViewModel(category: Category(id: "n/a", name: "--Select--", date: Date()))
    let categoryList = (categories.isEmpty) ? ([]) : categories.map(CellViewModel.init)
//    categoryList.insert(createNew, at: 0)
    tableData.replace(with: categoryList)
  }

  func isDuplicate(_ input: String) -> Bool {
    for category in categories where category.name == input {
      return true
    }
    return false
  }

  func changeSelectedIndex(to index: Int) {
    selectedIndex.value = index
  }

}
