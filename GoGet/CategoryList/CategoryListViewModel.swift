//
//  CategoryListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/30/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

enum SelectedOption: String {
    case rename
    case delete
}

protocol CategoryListViewModelType {
//    var alert: SafePassthroughSubject<Alert> { get }
    var tableData: MutableObservableArray<CategoryListCellViewModel> { get }
    func changeSelectedCategory(for index: Int?)
    func createNewCategory(action: UIAlertAction, for category: String)
    func renameCategory(action: UIAlertAction, with name: String)
    func deleteCategory(action: UIAlertAction)
    func changeSelectedIndex(to index: Int?)
}

final class CategoryListViewModel: CategoryListViewModelType {

//    var alert: SafePassthroughSubject<Alert>
    private let bag = DisposeBag()
    var tableData = MutableObservableArray<CategoryListCellViewModel>([])
    private var categories: [Category] = []
    var selectedID: Property<String?>
    var selectedIndex: Int?
    private let coordinator: CategoryListViewCoordinatorType
    private let getCategories: GetCategoriesType

    init(coordinator: CategoryListViewCoordinatorType,
         getCategories: GetCategoriesType = GetCategories(),
         selectedID: Property<String?>) {
        self.coordinator = coordinator
        self.selectedID = selectedID
        self.getCategories = getCategories
        fetchTableData()
        observeCategoryUpdates()
    }
}

extension CategoryListViewModel {

    func observeCategoryUpdates() {
        defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
            self.fetchTableData()
        }
        .dispose(in: bag)
    }
    func fetchTableData() {
        categories = getCategories.load()
        let categoryList = (categories.isEmpty) ? ([]) : categories.map(CategoryListCellViewModel.init)
        tableData.replace(with: categoryList)
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

    func createNewCategory(action: UIAlertAction, for category: String) {
        guard isValidName(category) == true else { return }
        let getCategories: GetCategoriesType = GetCategories()
        getCategories.createCategory(for: category)
    }

    func renameCategory(action: UIAlertAction, with name: String) {
        guard isValidName(name) == true else { return }
        guard let index = selectedIndex else { return }
        getCategories.renameCategory(index, to: name)
    }

    func deleteCategory(action: UIAlertAction) {
        guard let index = selectedIndex else { return }
        let category = categories[index]
        getCategories.deleteCategory(category.id)
    }

    func isValidName(_ category: String?) -> Bool {
        guard category != nil && category != "None" && category != " " else {
            coordinator.nameError(message: "Name not entered.")
            return false
        }
        for entry in categories where entry.name == category {
            coordinator.nameError(message: "Duplicate name.")
            return false
        }
        return true
    }
}
