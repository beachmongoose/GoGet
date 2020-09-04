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
  
  private let viewModel: FullListViewModelType
  
  init(viewModel: FullListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    override func viewDidLoad() {
      longPressDetector()
      addNewItemButton()
      title = "All Items"
      tableView.register(UINib(nibName: "FullListCell", bundle: nil), forCellReuseIdentifier: "FullListCell")
      super.viewDidLoad()
    }



}

// MARK: - TableView
extension FullListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tableData.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "FullListCell",
      for: indexPath)
      as? FullListCell else {
        fatalError("Unable to Dequeue")
      }
    
    let item = viewModel.tableData[indexPath.row]
        cell.item.text = item.name
        cell.dateBought.text = item.buyData
    
    return cell
  }
  
  
}

// MARK: - Item Config
extension FullListViewController {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let item = viewModel.selectedItem(index: indexPath.row)
    viewModel.presentDetail(item: item)
    }
  
  @objc func addItem() {
    viewModel.presentDetail(item: nil)
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
      self.viewModel.removeItem(at: itemIndex)
      self.tableView.reloadData()
    }))
    optionsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    present(optionsAlert, animated: true)
  }
  
}

// MARK: - Data Handling
extension FullListViewController {
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
}





