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
    func changeSelectedCategory(for index: Int?)
    func createNewCategory(for category: String)
    func deleteCategory(action: UIAlertAction)
    func changeSelectedIndex(to index: Int?)
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
    var selectedID: Property<String?>
    var selectedIndex: Int?
    private let coordinator: CategoryViewCoordinatorType
    private let getCategories: GetCategoriesType

    init(coordinator: CategoryViewCoordinatorType,
         getCategories: GetCategoriesType = GetCategories(),
         selectedID: Property<String?>) {
        self.coordinator = coordinator
        self.selectedID = selectedID
        self.getCategories = getCategories
        fetchTableData()
        observeCategoryUpdates()
    }
}

extension CategoryViewModel {

    func observeCategoryUpdates() {
        defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
            self.fetchTableData()
        }
        .dispose(in: bag)
    }
    func fetchTableData() {
        categories = getCategories.load()
        let categoryList = (categories.isEmpty) ? ([]) : categories.map(CellViewModel.init)
        tableData.replace(with: categoryList)
    }

    func isDuplicate(_ input: String) -> Bool {
        for category in categories where category.name == input {
            return true
        }
        return false
    }

    func changeSelectedCategory(for index: Int?) {
        guard let index = index else { selectedID.value = nil
            return
        }
        let category = getCategories.load()[index]
        selectedID.value = category.id
    }

    func changeSelectedIndex(to index: Int?) {
        selectedIndex = index
    }

    func createNewCategory(for category: String) {
        let getCategories: GetCategoriesType = GetCategories()
        getCategories.createCategory(for: category)
    }

    func deleteCategory(action: UIAlertAction) {
        guard let index = selectedIndex else { return }
        let category = categories[index]
        getCategories.deleteCategory(category.id)
    }
}
