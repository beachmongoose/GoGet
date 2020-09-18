//
//  GetExtensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

protocol GetCategoriesType {
  func load() -> [Category]
  func createCategory(for category: String) -> String
  func checkIfDuplicate(_ newCategory: String?) -> Bool
  func getName(for categoryID: String) -> String
}

class GetCategories: GetCategoriesType {

  let sortTypeInstance: SortingInstanceType
  let categoryStore: CategoryStoreType
  private var sortType: SortType {
    sortTypeInstance.sortType
  }

  init(sortTypeInstance: SortingInstanceType = SortingInstance.shared,
       categoryStore: CategoryStoreType = CategoryStore.shared) {
    self.sortTypeInstance = sortTypeInstance
    self.categoryStore = categoryStore
  }

  func save(_ categories: [Category]) {
    guard let persistenceData = categories.persistenceData else {
      print("Error")
      return
      }
    saveData(persistenceData)
  }

  func load() -> [Category] {
    var loadedCategories = [Category]()
    let data = loadData(for: "Category")
    guard data != nil else { return [] }

      do {
        let loadedData = try jsonDecoder.decode([Category].self, from: data!)
        loadedCategories = loadedData
        } catch {
          print("Failed to load categories")
      }
    return loadedCategories
  }

  func createCategory(for category: String) -> String {
    let newCategory = Category(name: category, added: Date())
    var categoryList = load()
    categoryList.append(newCategory)
    save(categoryList)
    return newCategory.nameId
  }

  func checkIfDuplicate(_ newCategory: String?) -> Bool {
    let categories = load()
    return (categories.map {$0.name == newCategory}).contains(true)
  }

  func updateCategory(_ category: Category, with newName: String) {
    var categories = load()
    for index in 0..<categories.count
    where categories[index].nameId == category.nameId {
        categories[index].name = newName
      }
    save(categories)
  }

  func getName(for categoryID: String) -> String {
    guard let category = categoryStore.categories[categoryID] else { return "Uncategorized" }
    return category.name
  }
}
