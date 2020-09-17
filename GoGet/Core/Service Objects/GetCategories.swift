//
//  GetExtensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

protocol GetCategoriesType {
  func loadCategories(orderBy: SortType) -> [Category]
  func createCategory(for category: String)
}

class GetCategories: GetCategoriesType {

  let sortTypeInstance: SortingInstanceType
  private var sortType: SortType {
    sortTypeInstance.sortType
  }

  init(sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
    self.sortTypeInstance = sortTypeInstance
  }

  func saveCategories(_ categories: [Category]) {
    guard let persistenceData = categories.persistenceData else {
      print("Error")
      return
      }
    saveData(persistenceData)
  }

  func loadCategories(orderBy: SortType) -> [Category] {
    var loadedCategories = [Category]()
    var sortedCategories = [Category]()
    let data = loadData(for: "Category")
    guard data != nil else { return [] }

      do {
        let loadedData = try jsonDecoder.decode([Category].self, from: data!)
        loadedCategories = loadedData
        } catch {
          print("Failed to load categories")
      }
    
    switch orderBy {
    case .name: sortedCategories = loadedCategories.sorted(by: { $0.name < $1.name } )
    case .date: sortedCategories = loadedCategories.sorted(by: { $0.added < $1.added } )
    case .added: sortedCategories = loadedCategories.sorted(by: { $0.added < $1.added } )
    }

    return (sortTypeInstance.sortAscending == true) ? sortedCategories : sortedCategories.reversed()
  }

  func createCategory(for category: String) {
    let newCategory = Category(name: category, nameId: getIDNumber(),   added: Date())
    var categoryList = loadCategories(orderBy: sortType)
    categoryList.append(newCategory)
    saveCategories(categoryList)
  }

  func getIDNumber() -> Int {
    let categories = loadCategories(orderBy: sortType)
    var idNumber = 0
    guard !categories.isEmpty else { return 0 }
    for entry in categories {
      if entry.nameId == idNumber {
        idNumber += 1
      }
    }
    return idNumber
  }

  func updateCategory(_ category: Category, with newName: String) {
    var categories = loadCategories(orderBy: sortType)
    for index in 0..<categories.count {
      if categories[index].nameId == category.nameId {
        categories[index].name = newName
      }
    }
    saveCategories(categories)
  }

  func sortItems(_ categories: [Category], items: [Item]) -> [[Item]] {
    var categoryArrays = [[Item]]()
    for _ in categories {
      categoryArrays.append([])
    }
    for item in items {
      guard item.category != nil else { continue }
      let int = categories.firstIndex(of: item.category!)!
      categoryArrays[int].append(item)
    }
    return categoryArrays
  }
}
