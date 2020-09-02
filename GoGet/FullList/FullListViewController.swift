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
  var sincePurchase: Int {
    return 4
  }
  
    override func viewDidLoad() {
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
    cell.item.text = item.name
    cell.daysAgoBought.text = "\(sincePurchase) days ago."
    
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
    let newItem = Item(name: "", quantity: 1, dateBought: Date(), duration: 7)
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
      itemDetail.newItem = bool
      itemDetail.itemNumber = number
      itemDetail.allItems = allItems
      navigationController?.pushViewController(itemDetail, animated: true)
    }
  }
}

// MARK: - Top Button
extension FullListViewController {
  func addNewItemButton() {
    let add = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addItem)
)
    navigationItem.rightBarButtonItem = add
  }
}

// MARK: - Data Handling
extension FullListViewController {
  func loadItems() {
    let defaults = UserDefaults.standard
    if let itemsData = defaults.object(forKey: "Items") as? Data {
      let json = JSONDecoder()
      
      do {
        allItems = try json.decode([Item].self, from: itemsData)
      } catch {
        print("Failed to Load")
      }
      tableView.reloadData()
    }
  }
  
  func save() {
    let json = JSONEncoder()
    if let savedData = try? json.encode(allItems) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "Items")
    } else {
      print("Failed to save")
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    loadItems()
  }
}





