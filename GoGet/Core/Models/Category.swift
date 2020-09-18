//
//  Category.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

struct Category: Codable, Hashable, Equatable {
  var nameId: String
  var name: String
}

extension Category {
  init(nameId: String = UUID().uuidString, name: String, added: Date) {
    self.name = name
    self.nameId = nameId
  }
}

extension Category {
  static func == (lhs: Category, rhs: Category) -> Bool {
    return lhs.nameId == rhs.nameId && lhs.name == rhs.name
  }
}
