//
//  Item.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

struct Item {
  var name: String
  var quantity: Int
  var dateBought: Date
  var duration: Int
}

extension Item {
  var isExpired: Bool {
//    if dateBought + duration > currentDate
    return true
  }
}
