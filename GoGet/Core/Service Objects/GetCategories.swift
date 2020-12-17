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

protocol GetCategoriesType {
    var categories: MutableObservableArray<Category> { get }
    func checkIfDuplicate(_ newCategory: String?) -> Bool
    func createCategory(for category: String)
    func deleteCategory(_ id: String)
    func forID(_ id: String) -> (Int, String)
    func renameCategory(_ index: Int, to newName: String)
    func save(_ categories: [Category])
}

class GetCategories: GetCategoriesType {
    var bag = DisposeBag()
    var categories = MutableObservableArray<Category>([])
    var rawData = [Category]()
    let sortTypeInstance: SortingInstanceType

    init(sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
        self.sortTypeInstance = sortTypeInstance
        load()
        observeSortTypeUpdates()
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
            rawData = try jsonDecoder.decode([Category].self, from: data!)
        } catch {
            print("Failed to load categories")
        }
        orderData()
    }

    func orderData() {
        var sortedCategories = [Category]()
        if sortTypeInstance.categorySortType.value == .name { sortedCategories = byName(rawData)
        } else {
            sortedCategories = byAdded(rawData)
        }
        categories.replace(with: (sortTypeInstance.categorySortAscending == true) ? sortedCategories : sortedCategories.reversed())
    }

    func byName(_ array: [Category]) -> [Category] {
        return array.sorted(by: { $0.name < $1.name })
    }

    func byAdded(_ array: [Category]) -> [Category] {
        return array.sorted(by: { $0.date < $1.date})
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

    func observeSortTypeUpdates() {
        sortTypeInstance.categorySortType.observeNext { [weak self] _ in
            if self?.rawData == [] { return }
            self?.orderData()
        }
        .dispose(in: bag)
    }
}
