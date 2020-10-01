//
//  CategoryListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/30/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol CategoryListViewModelType {
  var tableData: MutableObservableArray<CategoryListViewModel.CellViewModel> { get }
}

final class CategoryListViewModel: CategoryListViewModelType {
  struct CellViewModel {
    var name: String
    init(category: Category) {
      self.name = category.name
    }
  }

  var tableData = MutableObservableArray<CategoryListViewModel.CellViewModel>([])
  private var categories: [Category] = []
  private let getCategories: GetCategoriesType

  init(getCategories: GetCategoriesType, viewModel: CategoryListViewModelType) {
    self.getCategories = getCategories
    fetchTableData()
  }
}

extension CategoryListViewModel {
  func fetchTableData() {
    let categories = getCategories.load()
    self.categories = categories
    let cellViewModels = categories.map(CellViewModel.init)
    tableData.replace(with: cellViewModels)
  }
}
