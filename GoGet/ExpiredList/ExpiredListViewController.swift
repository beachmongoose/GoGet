//
//  ExpiredListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class ExpiredListViewController: UIViewController {

  var allItems = [Item]()
  var expiredItems = [Item]()
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension ExpiredListViewController {
  func getExpiredItems() {
    for item in allItems {
      let duration = item.duration
      if timeSinceBuying(item) > duration {
        expiredItems.append(item)
      }
    }
  }
  
  func timeSinceBuying(_ item: Item ) -> Int {
    let calendar = Calendar.autoupdatingCurrent
    let currentDate = calendar.startOfDay(for: Date())
    let buyDate = calendar.startOfDay(for: item.dateBought)

    let dayCount = calendar.dateComponents(
      [.day],
      from: currentDate, to: buyDate).day ?? 0

    return dayCount
  }
}
