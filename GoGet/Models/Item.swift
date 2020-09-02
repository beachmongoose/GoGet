//
//  Item.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

struct Item: Codable {
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
  
  var timeSinceBuying: Int {
    let calendar = Calendar.autoupdatingCurrent
    let currentDate = calendar.startOfDay(for: Date())
    let buyDate = calendar.startOfDay(for: dateBought)

    let dayCount = calendar.dateComponents(
      [.day],
      from: currentDate, to: buyDate).day ?? 0

    return dayCount
  }
}
