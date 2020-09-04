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
  
  private let coordinator: FullListCoordinatorType
  
  init(coordinator: FullListCoordinatorType) {
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
      longPressDetector()
      loadItems()
      addNewItemButton()
      title = "GoGet"
      tableView.register(UINib(nibName: "FullListCell", bundle: nil), forCellReuseIdentifier: "FullListCell")
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
      withIdentifier: "FullListCell",
      for: indexPath)
      as? FullListCell else {
        fatalError("Unable to Dequeue")
      }
    
    let item = allItems[indexPath.row]
    cell.item.text = "\(item.name) (\(item.quantity))"
    
    if item.bought == true {
      if item.timeSinceBuying > 1 || item.timeSinceBuying == 0 {
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
    coordinator.presentDetail(currentItem: selectedItem,
                              newItem: false,
                              index: indexPath.row)
    }
  
  @objc func addItem() {
    let newItem = Item(name: "", quantity: 1, dateBought: Date(), duration: 7, bought: false)
    coordinator.presentDetail(currentItem: newItem,
                              newItem: true,
                              index: 0)
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





