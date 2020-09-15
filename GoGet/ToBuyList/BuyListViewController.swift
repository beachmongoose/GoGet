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
  private let viewModel: BuyListViewModelType
    
  init(viewModel: BuyListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      setUpNavButton()
      longPressDetector()
      tableView.register(UINib(nibName: "BuyListCell", bundle: nil), forCellReuseIdentifier: "BuyListCell")
      title = "GoGet"
      super.viewDidLoad()
    }

}

// MARK: - Populate Table
extension BuyListViewController: UITableViewDataSource, UITableViewDelegate {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tableData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "BuyListCell",
      for: indexPath)
      as? BuyListCell else {
        fatalError("Unable to Dequeue")
      }
    let cellViewModel = viewModel.tableData[indexPath.row]
    cell.viewModel = cellViewModel
    return cell
  }
 
  
// MARK: - Change State
  func longPressDetector() {
    let longPressDetector = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    view.addGestureRecognizer(longPressDetector)
  }
  
  @objc func longPress(longPress: UILongPressGestureRecognizer) {
    if longPress.state == UIGestureRecognizer.State.began {
      let touchPoint = longPress.location(in: tableView)
      if let selectedItem = tableView.indexPathForRow(at: touchPoint) {
        viewModel.selectDeselectIndex(selectedItem.row)
        changeStatePrompt()
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.presentDetail(indexPath.row)
    self.tableView.reloadData()
  }
  
  func changeStatePrompt() {
    presentBoughtAlert(handler: markAsBought(action:))
  }
  
  @objc func markAsBought(action: UIAlertAction) {
    self.viewModel.markAsBought()
    self.tableView.reloadData()
  }
}

// MARK: - Navigation
extension BuyListViewController {
    func setUpNavButton() {
      let fullList = UIBarButtonItem(
        barButtonSystemItem: .organize,
        target: self,
        action: #selector(presentFullList))
      navigationItem.rightBarButtonItem = fullList
    }
}
  
  // MARK: - Sorting
  extension BuyListViewController {
    @IBAction func sortButton(_ sender: Any) {
      presentSortOptions(handler: sortMethod(action:))
      }
       
    @objc func sortMethod(action: UIAlertAction) {
      viewModel.sortBy(action.title!.lowercased())
      tableView.reloadData()
      }
  }
  
  
  extension BuyListViewController {
// MARK: - Data Handling
  @objc func presentFullList() {
    viewModel.presentFullList()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
}
