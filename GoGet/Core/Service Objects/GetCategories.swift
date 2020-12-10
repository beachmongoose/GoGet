//
//  GetExtensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

// TODO: SORT CATEGORIES OPTION
protocol GetCategoriesType {
    func save(_ categories: [Category])
    func createCategory(for category: String)
    func renameCategory(_ index: Int, to newName: String)
    func deleteCategory(_ id: String)
    func checkIfDuplicate(_ newCategory: String?) -> Bool
    func forID(_ id: String) -> (Int, String)
    var categories: MutableObservableArray<Category> { get }
}

class GetCategories: GetCategoriesType {
    var bag = DisposeBag()
    var categories = MutableObservableArray<Category>([])
    let sortTypeInstance: SortingInstanceType
    private var sortType: SortType {
        sortTypeInstance.sortType
    }

    init(sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
        self.sortTypeInstance = sortTypeInstance
        load()
        observeCategoriesUpdates()
    }

    func save(_ categories: [Category]) {
        guard let persistenceData = categories.persistenceData else {
            print("Error")
            return
        }
        saveData(persistenceData)
    }

    func load() {
        let data = loadData(for: "Categories")
        guard data != nil else { return }
        do {
            let loadedData = try jsonDecoder.decode([Category].self, from: data!)
            categories.replace(with: loadedData)
        } catch {
            print("Failed to load categories")
        }
    }

    func createCategory(for category: String) {
        let newCategory = Category(name: category, date: Date())
        categories.append(newCategory)
        save(categories.array)
    }

    func checkIfDuplicate(_ newCategory: String?) -> Bool {
        return (categories.array.map {$0.name == newCategory}).contains(true)
    }

    func updateCategory(_ category: Category, with newName: String) {
        for index in 0..<categories.count
        where categories[index].id == category.id {
            categories[index].name = newName
        }
        save(categories.array)
    }

    func forID(_ id: String) -> (Int, String) {
        let category = categories.array.first(where: { $0.id == id})
        let index = Int(categories.array.firstIndex(of: category!) ?? 0)
        return (index, category!.name)
    }

    func deleteCategory(_ id: String) {
        let index = forID(id)
        categories.remove(at: index.0)
        save(categories.array)
    }

    func renameCategory(_ index: Int, to newName: String) {
        categories[index].name = newName
        save(categories.array)
    }

    func observeCategoriesUpdates() {
        let defaults = UserDefaults.standard
        defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { [weak self] _ in
            self?.load()
        }
        .dispose(in: bag)
    }
}
