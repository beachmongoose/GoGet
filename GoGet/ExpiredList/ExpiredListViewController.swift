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
      getToBuyList()
      super.viewDidLoad()
    }

}

extension ExpiredListViewController {
  func getToBuyList() {
    for item in allItems {
      if item.needToBuy {
        expiredItems.append(item)
      }
    }
  }
}
