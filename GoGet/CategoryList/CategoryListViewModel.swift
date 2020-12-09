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
    var alert: SafePassthroughSubject<Alert> { get }
    var tableData: MutableObservableArray<CategoryListCellViewModel> { get }
    func changeSelectedCategory(for index: Int?)
    func deleteCategory()
    func changeSelectedIndex(to index: Int?)
    func changeSelection(to input: Int?)
    func longPressAlert()
    func newCategoryAlert()
    var nameData: Property<String> { get }
}

final class CategoryListViewModel: CategoryListViewModelType {

    var alert = SafePassthroughSubject<Alert>()
    var nameData = Property<String>("")
    var newCategory = true
    var vc = UIViewController()
    private let bag = DisposeBag()
    var tableData = MutableObservableArray<CategoryListCellViewModel>([])
//    private var categories: [Category] = []
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
        observeNameUpdates()
        observeCategoryUpdates()
    }
}

extension CategoryListViewModel {

    func observeCategoryUpdates() {
        getCategories.categories.observeNext { _ in
            self.fetchTableData()
        }
        .dispose(in: bag)
    }

    func observeNameUpdates() {
        nameData.removeDuplicates().observeNext { [weak self] data in
            guard data != "" else { return }
            if self?.newCategory == true {
                self?.createNewCategory(for: data)
            } else {
                self?.renameCategory(with: data)
            }
        }
        .dispose(in: bag)
    }
    func fetchTableData() {
        let categories = getCategories.categories.array
        let categoryList = (categories.isEmpty) ? ([]) : categories.map(CategoryListCellViewModel.init)
        tableData.replace(with: categoryList)
    }

    func changeSelectedCategory(for index: Int?) {
        guard let index = index else { selectedID.value = nil
            return
        }
        let category = getCategories.categories.array[index]
        selectedID.value = category.id
    }

    func changeSelectedIndex(to index: Int?) {
        selectedIndex = index
    }

    func changeSelection(to input: Int?) {
        changeSelectedIndex(to: input)
        changeSelectedCategory(for: input)
    }

    func createNewCategory(for category: String) {
        guard isValidName(category) == true else { return }
        getCategories.createCategory(for: category)
    }

    func renameCategory(with name: String) {
        guard isValidName(name) == true else { return }
        guard let index = selectedIndex else { return }
        getCategories.renameCategory(index, to: name)
    }

    func deleteCategory() {
        guard let index = selectedIndex else { return }
        let category = getCategories.categories[index]
        getCategories.deleteCategory(category.id)
    }

    func isValidName(_ category: String?) -> Bool {
        let blank = ""
        guard category != nil && category != "None" && category != blank else {
            coordinator.nameError(message: "Name not entered.")
            return false
        }
        for entry in getCategories.categories.array where entry.name == category {
            coordinator.nameError(message: "Duplicate name.")
            return false
        }
        return true
    }
}

extension CategoryListViewModel {

    func longPressAlert() {
        let deleteOption = Alert.Action(title: "Delete", action: deleteAlert)
        let editOption = Alert.Action(title: "Rename", action: renameAlert)
        let deleteOrRenameAlert = Alert(title: "Category Selected", message: nil, otherActions: [deleteOption, editOption])
        alert.send(deleteOrRenameAlert)
    }

    func deleteAlert() {
        let deleteOption = Alert.Action(title: "Yes") { [weak self] in
            self?.deleteCategory()
            self?.changeSelection(to: nil)
        }
        let noOption = Alert.Action(title: "No")
        let delete = Alert(title: "Delete Category?", message: nil, cancelAction: noOption, otherActions: [deleteOption])
        alert.send(delete)
    }

    func renameAlert() {
        let cancelOption = Alert.Action(title: "Cancel")
        let renameCategory = Alert(title: "Enter Category Name", message: nil, cancelAction: cancelOption, textFieldData: .yes(nameData))
        newCategory = false
        alert.send(renameCategory)
    }

    func newCategoryAlert() {
        let cancelOption = Alert.Action(title: "Cancel")
        let nameCategory = Alert(title: "Enter Category Name", message: nil, cancelAction: cancelOption, textFieldData: .yes(nameData))
        newCategory = true
        alert.send(nameCategory)
    }

    func nameError() {
        let invalidName = Alert(title: "Invalid Name", message: nil)
        alert.send(invalidName)
    }

    func addCategoryAlert() {
        let okOption = Alert.Action(title: "OK")
        let confirmCategory = Alert(title: "Category Saved", message: nil, cancelAction: okOption)
        alert.send(confirmCategory)
    }
}
