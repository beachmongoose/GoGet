//
//  ExpiredListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class BuyListViewController: UIViewController {

  var allItems = [Item]()
  var toBuyItems = [Item]()
  
    override func viewDidLoad() {
      getToBuyList()
      super.viewDidLoad()
    }

}

extension BuyListViewController {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return toBuyItems.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(
//      withIdentifier: "buyListCell",
//      for: indexPath)
//      as? BuyListCell else {
//        fatalError("Unable to Dequeue")
//      }
//
//    let item = toBuyItems[indexPath.row]
//    cell.item.text = "\(item.name), (\(item.quantity))"
//
//    if item.bought == true {
//      if item.quantity > 1 {
//        cell.daysAgoBought.text = "\(item.timeSinceBuying) days ago"
//      } else {
//        cell.daysAgoBought.text = "1 day ago"
//      }
//    } else {
//      cell.daysAgoBought.text = "Not bought"
//    }
//
//    return cell
//  }
}

extension BuyListViewController {
  func getToBuyList() {
    for item in allItems {
      if item.needToBuy {
        toBuyItems.append(item)
      }
    }
  }
}
