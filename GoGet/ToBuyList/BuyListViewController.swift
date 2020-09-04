//
//  ExpiredListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class BuyListViewController: UIViewController {

  @IBOutlet var tableView: UITableView!
  var allItems = [Item]()
  var toBuyItems = [Item]()
  
  private let getItems: GetItemsType = GetItems()
    
  init(coordinator: BuyListCoordinatorType) {
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      setUpNavButton()
      setUpBuyList()
      tableView.register(UINib(nibName: "BuyListCell", bundle: nil), forCellReuseIdentifier: "BuyListCell")
      super.viewDidLoad()
    }

}

extension BuyListViewController: UITableViewDataSource, UITableViewDelegate {
  
    func setUpNavButton() {
      let fullList = UIBarButtonItem(
        barButtonSystemItem: .add,
        target: self,
        action: #selector(presentFullList))
      navigationItem.rightBarButtonItem = fullList
    }
  
  @objc func presentFullList() {
    coordinator.presentFullList()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return toBuyItems.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "BuyListCell",
      for: indexPath)
      as? BuyListCell else {
        fatalError("Unable to Dequeue")
      }

    let item = toBuyItems[indexPath.row]
    cell.item.text = "\(item.name), (\(item.quantity))"

    if item.bought == true {
      if item.timeSinceBuying > 1 || item.timeSinceBuying == 0 {
        cell.dateBought.text = "\(item.timeSinceBuying) days ago"
      } else {
        cell.dateBought.text = "1 day ago"
      }
    } else {
      cell.dateBought.text = "Not bought"
    }

    return cell
  }
}

extension BuyListViewController {
  func setUpBuyList() {
    allItems = getItems.load()
    for item in allItems {
      if item.needToBuy {
        toBuyItems.append(item)
      }
    }
    tableView.reloadData()
  }
}
