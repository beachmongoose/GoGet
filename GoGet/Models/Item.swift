//
//  Item.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation
import UIKit

struct Item: Codable {
  var name: String
  var quantity: Int
  var dateBought: Date
  var duration: Int
  var bought: Bool
}

extension Item {
  var needToBuy: Bool {
    timeSinceBuying > duration || bought == false
  }
  
  var timeSinceBuying: Int {
    let calendar = Calendar.autoupdatingCurrent
    let currentDate = calendar.startOfDay(for: Date())
    let buyDate = calendar.startOfDay(for: dateBought)

    let dayCount = calendar.dateComponents(
      [.day],
      from: buyDate, to: currentDate).day ?? 0

    return dayCount
  }
}
