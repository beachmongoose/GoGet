//
//  FullListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class FullListViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  var allItems = [Item]()
  var expiredItems = [Item]()
  private let getItems: GetItemsType = GetItems()
  
    override func viewDidLoad() {
      longPressDetector()
      loadItems()
      addNewItemButton()
      title = "GoGet"
      super.viewDidLoad()
    }



}

// MARK: - TableView
extension FullListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return allItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "fullListCell",
      for: indexPath)
      as? FullListCell else {
        fatalError("Unable to Dequeue")
      }
    
    let item = allItems[indexPath.row]
    cell.item.text = "\(item.name) (\(item.quantity))"
    
    if item.bought == true {
      if item.quantity > 1 {
        cell.daysAgoBought.text = "\(item.timeSinceBuying) days ago"
      } else {
        cell.daysAgoBought.text = "1 day ago"
      }
    } else {
      cell.daysAgoBought.text = "Not bought"
    }
    
    return cell
  }
  
  
}

// MARK: - Item Config
extension FullListViewController {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let selectedItem = allItems[indexPath.row]
    goToDetailView(currentItem: selectedItem,
                   newItemBool: false,
                   index: indexPath.row)
    }
  
  @objc func addItem() {
    let newItem = Item(name: "", quantity: 1, dateBought: Date(), duration: 7, bought: false)
    goToDetailView(currentItem: newItem,
                   newItemBool: true,
                   index: 0)
  }
  
  func goToDetailView(currentItem item: Item,
                      newItemBool bool: Bool,
                      index number: Int) {
    if let itemDetail = storyboard?.instantiateViewController(
      withIdentifier: "itemDetail")
      as? DetailViewController {
      
      itemDetail.currentItem = item
      itemDetail.boughtDate = item.dateBought
      itemDetail.newItem = bool
      itemDetail.itemNumber = number
      itemDetail.allItems = allItems
      navigationController?.pushViewController(itemDetail, animated: true)
    }
  }
}

// MARK: - User Input
extension FullListViewController: UIGestureRecognizerDelegate {
  func addNewItemButton() {
    let add = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addItem)
)
    navigationItem.rightBarButtonItem = add
  }
  func longPressDetector() {
  let longPressDetector = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
  view.addGestureRecognizer(longPressDetector)
  }
  
  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: tableView)
      if let selectedItem = tableView.indexPathForRow(at: touchPoint) {
        deletePrompt(selectedItem.row)
      }
    }
  }
  
  func deletePrompt(_ itemIndex: Int) {
    let optionsAlert = UIAlertController(title: "Item Selected", message: nil, preferredStyle: .alert)
    optionsAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
      self.allItems.remove(at: itemIndex)
      self.getItems.save(self.allItems)
      self.tableView.reloadData()
    }))
    optionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(optionsAlert, animated: true)
  }
  
}

// MARK: - Data Handling
extension FullListViewController {
  func loadItems() {
    allItems = getItems.load()
    tableView.reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadItems()
  }
}





