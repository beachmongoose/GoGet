//
//  CategoryInputCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol CategoryInputCellViewModelType: InputCellViewModelType {
    var title: String { get }
    var initialValue: String { get }
    var updatedValue: Property<String?> { get }
    var selectedCategoryName: Property<String> { get }
    var selectedCategoryIndex: Observable<Int?> { get }
}

final class CategoryInputCellViewModel: CategoryInputCellViewModelType {
    var title: String
    var initialValue: String
    var updatedValue = Property<String?>(nil)
    var selectedCategoryName = Property<String>("None")
    var selectedCategoryIndex = Observable<Int?>(nil)
    var isValid = Property<Bool>(true)
    let bag = DisposeBag()

    var categories: [Category] = []
    private let getCategories: GetCategoriesType

    init(title: String, initialValue: String, updatedValue: Property<String?>, getCategories: GetCategoriesType = GetCategories()) {
        self.title = title
        self.initialValue = initialValue
        self.updatedValue = updatedValue
        self.getCategories = getCategories
        categories = getCategories.load()
        fetchCategory()
        observeInput()
  }
}

extension CategoryInputCellViewModel {

    func fetchCategory() {
        guard let data = (updatedValue.value == nil) ? initialValue : updatedValue.value else { return }
        guard data != "None" else { selectedCategoryName.value = data
            return }
        let category = getCategories.forID(data)
        selectedCategoryIndex.value = category.0
        selectedCategoryName.value = category.1
    }

    func observeInput() {
        updatedValue.observeNext { value in
            guard value != "None" else { self.updatedValue.value = value
                return
            }
            self.fetchCategory()
        }
        .dispose(in: bag)
    }
    func checkForCategory(_ id: String?) {
        guard let id = id else { updatedValue.value = "None"
            return
        }
    let data = getCategories.forID(id)
    selectedCategoryIndex.value = data.0
        selectedCategoryName.value = data.1
    }

//    func presentPopover(sender: UIButton) {
//    coordinator.presentPopover(sender: sender, selectedIndex: selectedCategoryIndex)
//    }
}
