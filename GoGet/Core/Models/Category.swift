//
//  Category.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

struct Category: Codable, Equatable {
  var nameId: String
  var name: String
}

extension Category {
  init(nameId: String = UUID().uuidString, name: String, date: Date) {
    self.nameId = nameId
    self.name = name
  }
}

extension Category {
  static func == (lhs: Category, rhs: Category) -> Bool {
    return lhs.nameId == rhs.nameId && lhs.name == rhs.name
  }
}
