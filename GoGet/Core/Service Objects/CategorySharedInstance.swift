//
//  CategorySharedInstance.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/18/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

typealias CategoryID = String

protocol CategoryStoreType {
  func getDictionary() -> [String: Category]
//  var categories: [CategoryID: Category] { get }
}

class CategoryStore: CategoryStoreType {
  static let shared = CategoryStore()
  var categories: [String: Category] = [:]
  private let getCategories: GetCategoriesType

  init(getCategories: GetCategoriesType = GetCategories(),
       categories: [String: Category] = [:]) {
    self.getCategories = getCategories
//    self.categories = getDictionary()
  }

  func getDictionary() -> [String: Category] {
    let categories = getCategories.load()
    let data = categories.reduce(into: [:]) { dict, category in
      dict[category.nameId] = category
    }
    return data
  }
}
