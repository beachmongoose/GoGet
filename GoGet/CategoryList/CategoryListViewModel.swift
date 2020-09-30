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
  var tableData: MutableObservableArray<String> { get }
}

final class CategoryListViewModel: CategoryListViewModelType {
  
  var tableData = MutableObservableArray<String>(Array([]))
  private let getCategories: GetCategoriesType
  private let viewModel: CategoryListViewModelType
  
  init(getCategories: GetCategoriesType, viewModel: CategoryListViewModelType) {
    self.getCategories = getCategories
    self.viewModel = viewModel
    fetchTableData()
  }
}

extension CategoryListViewModel {
  func fetchTableData() {
    let data = getCategories.load()
    for category in data {
      tableData.append(category.name)
    }
  }
}
