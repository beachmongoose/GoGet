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
  var categories: [CategoryID: Category] { get }
}

class CategoryStore: CategoryStoreType {
  static let shared = CategoryStore()
  var categories: [String: Category] = [:]
  private let getCategories: GetCategoriesType

  init(getCategories: GetCategoriesType = GetCategories()) {
    self.getCategories = getCategories
    getDictionary()
  }

  func getDictionary() {
    let categories = getCategories.load()
    let data = categories.reduce(into: [:]) { dict, category in
      dict[category.nameId] = category
    }
    self.categories = data
  }
}
