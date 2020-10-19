//
//  FullListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class FullListViewController: UIViewController {
  var sortButton: UIBarButtonItem
  var confirmButton: UIBarButtonItem
  var cancelButton: UIBarButtonItem
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
      setupTable()
      setupNavigationBar()
      observeEditModeUpdates()
      super.viewDidLoad()
    }
}

// MARK: - View Setup
extension FullListViewController: UITableViewDelegate {
  func setupTable() {
    tableView.register(UINib(nibName: "FullListCell", bundle: nil), forCellReuseIdentifier: "FullListCell")
    let dataSource =
      SectionedTableViewBinderDataSource<FullListViewModel.CellViewModel>(createCell: createCell)
    viewModel.tableData.bind(to: tableView, using: dataSource)
    tableView.delegate = self
  }

  func observeEditModeUpdates() {
    viewModel.inDeleteMode.observeNext { [self] _ in
      let deleteMode = viewModel.inDeleteMode.value
      viewModel.clearIndex()
      tableView.allowsMultipleSelection = deleteMode
      sortButton.isEnabled.toggle()
      if !deleteMode {
//        menuButton()
      } else {
        confirmAndCancelButtons()
      }
    }
    .dispose(in: bag)
  }

  private func createCell(dataSource: Array2D<String, FullListViewModel.CellViewModel>,
                        indexPath: IndexPath,
                        tableView: UITableView) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "FullListCell",
      for: indexPath
    ) as? FullListCell else {
          fatalError("Unable to Dequeue")
    }
    let cellViewModel = dataSource[childAt: indexPath].item
    cell.viewModel = cellViewModel
    cell.reactive.longPressGesture().observeNext { _ in
      self.viewModel.inDeleteMode.value.toggle()
    }
    .dispose(in: bag)
    return cell
  }
}
// MARK: - Navigation
extension FullListViewController {

  func setupNavigationBar() {
    sortButton = UIBarButtonItem(title: "Sort",
                                 style: .plain,
                                 target: nil,
                                 action: #selector(sortMenu))
    confirmButton = UIBarButtonItem(title: "Confirm",
                                  style: .plain,
                                  target: self,
                                  action: #selector(confirmDelete))
    cancelButton = UIBarButtonItem(title: "Cancel",
                                 style: .plain,
                                 target: self,
                                 action: #selector(cancelDelete))
    navigationItem.rightBarButtonItem = sortButton
  }

  func confirmAndCancelButtons() {
    navigationItem.rightBarButtonItem = cancelButton
    navigationItem.leftBarButtonItem = confirmButton
  }
  func menuButton() {
    navigationItem.rightBarButtonItem = sortButton
    navigationItem.leftBarButtonItem = nil
  }
}

// MARK: - User Input
extension FullListViewController: UIGestureRecognizerDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if !viewModel.inDeleteMode.value {
        viewModel.editItem(indexPath)
      } else {
        viewModel.selectDeselectIndex(at: indexPath)
      }
    }

  @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {
      let touchPoint = longPressGestureRecognizer.location(in: tableView)
      viewModel.clearIndex()
      if let selectedItem = tableView.indexPathForRow(at: touchPoint) {
        viewModel.changeEditing()
        viewModel.selectDeselectIndex(at: selectedItem)
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
    viewModel.changeEditing()
  }

  @objc func confirmDelete() {
    presentConfirmRequest(handler: removeItems(action:))
  }

  @objc func removeItems(action: UIAlertAction) {
    viewModel.removeItems()
    viewModel.changeEditing()
    tableView.reloadData()
  }

  @objc func cancelDelete() {
    viewModel.clearIndex()
    viewModel.changeEditing()
    tableView.reloadData()
  }
}

// MARK: - Sorting
extension FullListViewController {

  @IBAction func sortMenu(_ sender: Any) {
    presentSortOptions(handler: sortMethod(action:))
  }

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
}
