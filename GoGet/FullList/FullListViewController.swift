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
    cell.item.text = item.name
    cell.daysAgoBought.text = "\(timeSinceBuying(item)) days ago"
    
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
      self.save()
      self.tableView.reloadData()
    }))
    optionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(optionsAlert, animated: true)
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

extension FullListViewController {
  
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





