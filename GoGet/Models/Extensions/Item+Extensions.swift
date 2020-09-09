//
//  Item+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/9/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

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
  
  var buyData: String {
    if !bought {
      return "Not bought"
    }
    if timeSinceBuying > 1 || timeSinceBuying == 0 {
      return "\(timeSinceBuying) days ago"
    } else {
      return "1 day ago"
    }
  }
}
