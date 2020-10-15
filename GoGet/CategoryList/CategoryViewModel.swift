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
  func createNewCategory(for category: String) -> Int
  func deleteCategory(action: UIAlertAction)
}

final class CategoryViewModel: CategoryListViewModelType {
  struct CellViewModel {
    var name: String
    init(category: Category) {
      self.name = category.name
    }
  }

  private let bag = DisposeBag()
  var tableData = MutableObservableArray<CategoryCell>([])
  private var categories: [Category] = []
  var selectedIndex: Property<Int?>
  private let coordinator: CategoryViewCoordinatorType
  private let getCategories: GetCategoriesType

  init(coordinator: CategoryViewCoordinatorType,
       getCategories: GetCategoriesType = GetCategories(),
       selectedIndex: Property<Int?>) {
    self.coordinator = coordinator
    self.selectedIndex = selectedIndex
    self.getCategories = getCategories
    fetchTableData()
    observeCategoryUpdates()
  }
}

extension CategoryViewModel {

  func observeCategoryUpdates() {
    defaults.reactive.keyPath("Categories", ofType: Data.self, context: .immediateOnMain).observeNext { _ in
      self.fetchTableData()
    }
    .dispose(in: bag)
  }
  func fetchTableData() {
    let categories = getCategories.load()
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

  func createNewCategory(for category: String) -> Int {
    let getCategories: GetCategoriesType = GetCategories()
    let index = getCategories.createCategory(for: category)
    return index
  }

  func deleteCategory(action: UIAlertAction) {
    categories.remove(at: selectedIndex.value!)
  }

}
