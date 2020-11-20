//
//  Item+Test.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 11/20/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

@testable import GoGet
import Foundation

extension Item {
  static let test = Item(
    name: "Test",
    id: "id",
    quantity: 1,
    duration: 7,
    boughtStatus: .notBought,
    dateAdded: Date(),
    categoryID: nil)
}
