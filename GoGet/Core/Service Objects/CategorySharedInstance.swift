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
  var categories: [String: Category] { get }
}

class CategoryStore: CategoryStoreType {

  var categories: [String: Category] = [:]
  let getCategories: GetCategoriesType

  init(getCategories: GetCategoriesType = GetCategories()) {
    self.getCategories = getCategories
    getDictionary()
  }

  static var shared = CategoryStore()

  func getDictionary() {
    let categories = getCategories.load()
    let data = categories.reduce(into: [:]) { dict, category in
      dict[category.nameId] = category
    }
    self.categories = data
  }

}
