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
  @IBOutlet var sortButton: UIButton!
  private let viewModel: FullListViewModelType
  var inDeleteMode = false

  init(viewModel: FullListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
    override func viewDidLoad() {
//      longPressDetector()
//      addNewAndDeleteButtons()
      tableView.register(UINib(nibName: "FullListCell", bundle: nil), forCellReuseIdentifier: "FullListCell")
      setupTable()
      observeButtonEvents()
      super.viewDidLoad()
    }

  func observeButtonEvents() {
    sortButton.reactive.tap.bind(to: self) { $0.viewModel.clear() }
  }

  func setupTable() {
    viewModel.observableTableData.bind(to: tableView) { dataSource, indexPath, tableView in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullListCell", for: indexPath)
        as? FullListCell else { fatalError("Unable to Dequeue") }

      let cellViewModel = dataSource[indexPath.row]
      cell.viewModel = cellViewModel
      return cell
    }
  }
}

//// MARK: - TableView
//extension FullListViewController: UITableViewDataSource, UITableViewDelegate {
//
//  func numberOfSections(in tableView: UITableView) -> Int {
//    return viewModel.tableData.count
//  }
//
//  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//    viewModel.tableData[section].0
//  }
//
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return viewModel.tableData[section].1.count
//  }
//
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//    guard let cell = tableView.dequeueReusableCell(
//      withIdentifier: "FullListCell",
//      for: indexPath)
//      as? FullListCell else {
//        fatalError("Unable to Dequeue")
//      }
//
//    let cellViewModel = viewModel.tableData[indexPath.section].1[indexPath.row]
//    cell.viewModel = cellViewModel
//    return cell
//  }
//}

// MARK: - Buttons
extension FullListViewController: UIGestureRecognizerDelegate {

  func addNewAndDeleteButtons() {
    let add = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(addItem))
    let delete = UIBarButtonItem(
      title: "Delete",
      style: .plain,
      target: self,
      action: #selector(massDeleteMode))
    navigationItem.rightBarButtonItems = [add, delete]
    navigationItem.leftBarButtonItem = navigationItem.backBarButtonItem
  }

  func addConfirmAndCancelButtons() {
    let confirm = UIBarButtonItem(title: "Confirm",
                                  style: .plain,
                                  target: self,
                                  action: #selector(confirmDelete))
    let cancel = UIBarButtonItem(title: "Cancel",
                                 style: .plain,
                                 target: self,
                                 action: #selector(cancelDelete))
    navigationItem.rightBarButtonItems = [cancel]
    navigationItem.leftBarButtonItem = confirm
  }

}
// MARK: - User Input
extension FullListViewController {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if !inDeleteMode {
      viewModel.editItem(in: indexPath.section, at: indexPath.row)
      } else {
        viewModel.selectDeselectIndex(in: indexPath.section, at: indexPath.row)
      self.tableView.reloadData()
      }
    }

    @objc func addItem() {
      viewModel.presentDetail(for: nil)
    }

  func longPressDetector() {
  let longPressDetector = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
  view.addGestureRecognizer(longPressDetector)
  }

  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: tableView)
      viewModel.clearIndex()
      if let selectedItem = tableView.indexPathForRow(at: touchPoint) {
        viewModel.selectDeselectIndex(in: selectedItem.section, at: selectedItem.row)
        deletePrompt(selectedItem.row)
      }
    }
  }
}

  // MARK: - Removing Items
extension FullListViewController {
  func deletePrompt(_ itemIndex: Int) {
    presentDeleteAlert(handler: removeItems)
  }

  @objc func massDeleteMode() {
    changeEditing(to: true)
  }

  @objc func confirmDelete() {
    presentConfirmRequest(handler: removeItems(action:))
  }

  @objc func removeItems(action: UIAlertAction) {
    viewModel.removeItems()
    changeEditing(to: false)
    tableView.reloadData()
  }

  @objc func cancelDelete() {
    viewModel.clearIndex()
    changeEditing(to: false)
    self.tableView.reloadData()
  }
}

// MARK: - Sorting
extension FullListViewController {
//  @IBAction func sortButton(_ sender: Any) {
//    presentSortOptions(handler: sortMethod(action:))
//  }

  @objc func sortMethod(action: UIAlertAction) {
    viewModel.sortBy(action.title!.lowercased())
    tableView.reloadData()
  }
}

// MARK: - Data Handling
extension FullListViewController {

  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }

  override func viewWillDisappear(_ animated: Bool) {
    viewModel.goingBack()
  }

  func changeEditing(to bool: Bool) {
    inDeleteMode = bool
    tableView.allowsMultipleSelection = bool
    sortButton.isEnabled.toggle()
    if bool == false {
      longPressDetector()
      addNewAndDeleteButtons()
    } else {
      addConfirmAndCancelButtons()
      view.gestureRecognizers?.removeAll()
    }
  }
}
