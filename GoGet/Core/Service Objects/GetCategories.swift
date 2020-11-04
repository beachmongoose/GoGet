//
//  GetExtensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

// TODO: SORT CATEGORIES OPTION
protocol GetCategoriesType {
  func load() -> [Category]
  func save(_ categories: [Category])
  func createCategory(for category: String)
  func deleteCategory(_ id: String)
  func checkIfDuplicate(_ newCategory: String?) -> Bool
  func forID(_ id: String) -> (Int, String)
}

class GetCategories: GetCategoriesType {

  let sortTypeInstance: SortingInstanceType
  private var sortType: SortType {
    sortTypeInstance.sortType
  }

  init(sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
    self.sortTypeInstance = sortTypeInstance
  }

  func save(_ categories: [Category]) {
    guard let persistenceData = categories.persistenceData else {
      print("Error")
      return
      }
    saveData(persistenceData)
  }

  func load() -> [Category] {
//    let sortType = sortTypeInstance.sortType
    var loadedCategories = [Category]()
//    var sortedCategories = [Category]()
    let data = loadData(for: "Categories")
    guard data != nil else { return [] }
      do {
        let loadedData = try jsonDecoder.decode([Category].self, from: data!)
        loadedCategories = loadedData
        } catch {
          print("Failed to load categories")
        }
    return loadedCategories
//    switch sortType {
//    case .name: sortedCategories = loadedCategories.sorted(by: { $0.name < $1.name })
//    case .date: sortedCategories = sortByDate(loadedCategories)
//    case .added: sortedCategories = sortByDate(loadedCategories)
//    }
//    return (sortTypeInstance.sortAscending == true) ? sortedCategories : sortedCategories.reversed()
  }

//  func sortByDate(_ categories: [Category]) -> [Category] {
//    return categories.sorted(by: { $0.date < $1.date })
//  }

  func createCategory(for category: String) {
    let newCategory = Category(name: category, date: Date())
    var categoryList = load()
    categoryList.append(newCategory)
    save(categoryList)
  }

  func checkIfDuplicate(_ newCategory: String?) -> Bool {
    let categories = load()
    return (categories.map {$0.name == newCategory}).contains(true)
  }

  func updateCategory(_ category: Category, with newName: String) {
    var categories = load()
    for index in 0..<categories.count
    where categories[index].id == category.id {
        categories[index].name = newName
      }
    save(categories)
  }

  func forID(_ id: String) -> (Int, String) {
    let categories = load()
    let category = categories.first(where: { $0.id == id})
    let index = Int(categories.firstIndex(of: category!) ?? 0)
    return (index, category!.name)
  }

  func deleteCategory(_ id: String) {
    var categories = load()
    let index = forID(id)
    categories.remove(at: index.0)
    save(categories)
  }
}
