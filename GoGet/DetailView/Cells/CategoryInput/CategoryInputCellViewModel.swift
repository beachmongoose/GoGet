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
    var selectedCategory: Category? { get }
    var selectedCategoryIndex: Observable<Int?> { get }
}

final class CategoryInputCellViewModel: CategoryInputCellViewModelType {
    var title: String
    var initialValue: String
    var updatedValue = Property<String?>(nil)
    var selectedCategory = Category?(nil)
    var selectedCategoryIndex = Observable<Int?>(nil)
    var isValid = Property<Bool>(true)

    var categories: [Category] = []
    private let getCategories: GetCategoriesType

    init(title: String, initialValue: String, getCategories: GetCategoriesType = GetCategories()) {
        self.title = title
        self.initialValue = initialValue
        self.getCategories = getCategories
        categories = getCategories.load()
  }
}

extension CategoryInputCellViewModel {

    func observeInitialValue() {
        updatedValue.observeNext { value in
            guard value != "None" else { self.updatedValue.value = value
                return
            }
            self.checkForCategory(value)
        }
        .dispose()
    }
    func checkForCategory(_ id: String?) {
        guard let id = id else { updatedValue.value = "None"
            return
        }
    let data = getCategories.forID(id)
    selectedCategoryIndex.value = data.0
    selectedCategory = data.1
    updatedValue.value = selectedCategory?.name
    }

//    func presentPopover(sender: UIButton) {
//    coordinator.presentPopover(sender: sender, selectedIndex: selectedCategoryIndex)
//    }

    func observeCategoryUpdates() {
        defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
        self.categories = self.getCategories.load()
    }
    .dispose()
    }

    func observeCategorySelection() {
    selectedCategoryIndex.observeNext { index in
        let category = (self.categories.count == 0 || index == nil) ? nil : self.categories[index ?? 0]
        self.selectedCategory = category
        self.updatedValue.value = category?.name ?? nil
    }
    .dispose()
    }
}
