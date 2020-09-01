//
//  FullListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class FullListViewController: UIViewController {
  var allItems = [Item]()
  var expiredItems = [Item]()
  var sincePurchase: Int {
    return 4
  }
  
    override func viewDidLoad() {
      
      addNewItemButton()
      
        super.viewDidLoad()
    }



}

// MARK: - TableView
extension FullListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "fullListCell", for: indexPath) as? FullListCell else {
          fatalError("Unable to Dequeue")
          }
    
    let item = allItems[indexPath.row]
    cell.item.text = item.name
    cell.daysAgoBought.text = "Bought \(sincePurchase) days ago."
    
    return cell
  }
  
  
}

// MARK: - Adding
extension FullListViewController {
  @objc func addItem() {
    if let itemDetail = storyboard?.instantiateViewController(withIdentifier: "itemDetail") as? DetailViewController {
      let newItem = Item(name: "", quantity: 1, dateBought: Date(), duration: 7)
      itemDetail.currentItem = newItem
      itemDetail.newItem = true
      navigationController?.pushViewController(itemDetail, animated: true)
    }
  }
}

// MARK: - Top Button
extension FullListViewController {
  func addNewItemButton() {
    let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
    navigationItem.rightBarButtonItem = add
  }
}
