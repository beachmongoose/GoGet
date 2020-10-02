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
}

final class CategoryViewModel: CategoryListViewModelType {
  struct CellViewModel {
    var name: String
    init(category: Category) {
      self.name = category.name
    }
  }

  var tableData = MutableObservableArray<CategoryCell>([])
  private var categories: [Category] = []
  private let coordinator: CategoryViewCoordinatorType

  init(coordinator: CategoryViewCoordinatorType, categories: [Category]) {
    self.coordinator = coordinator
    fetchTableData()
  }
}

extension CategoryViewModel {
//  func fetchTableData() {
//    let categories = getCategories.load()
//    self.categories = categories
//    let cellViewModels = categories.map(CellViewModel.init)
//    tableData.replace(with: cellViewModels)
//  }

  func fetchTableData() {
    let data = (!categories.isEmpty) ? ([]) : categories.map(CellViewModel.init)
    tableData.replace(with: data)
  }
}
