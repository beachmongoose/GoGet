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
  var sortButton: UIBarButtonItem!
  var confirmButton: UIBarButtonItem!
  var cancelButton: UIBarButtonItem!
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
    cell.reactive.longPressGesture().removeDuplicates().observeNext { _ in
      self.viewModel.selectDeselectIndex(at: indexPath)
      self.viewModel.inDeleteMode.value.toggle()
    }
    .dispose(in: cell.bag)
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
  func addSortButton() {
    navigationItem.rightBarButtonItem = sortButton
    navigationItem.leftBarButtonItem = nil
  }

  func observeEditModeUpdates() {
    viewModel.inDeleteMode.observeNext { [self] _ in
      let deleteMode = viewModel.inDeleteMode.value
      tableView.allowsMultipleSelection = deleteMode
      if deleteMode == false {
        viewModel.clearSelectedItems()
        addSortButton()
      } else {
        confirmAndCancelButtons()
      }
    }
    .dispose(in: bag)
  }
}

// MARK: - User Input
extension FullListViewController: UIGestureRecognizerDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if viewModel.inDeleteMode.value == false {
      viewModel.presentDetail(indexPath)
    } else {
      viewModel.selectDeselectIndex(at: indexPath)
    }
  }
}

  // MARK: - Removing Items
extension FullListViewController {
  func deletePrompt(_ itemIndex: Int) {
    presentDeleteAlert(handler: removeItems)
  }

  @objc func confirmDelete() {
    presentConfirmRequest(handler: removeItems(action:))
  }

  @objc func removeItems(action: UIAlertAction) {
    viewModel.removeItems()
    viewModel.changeEditing()
  }

  @objc func cancelDelete() {
    viewModel.clearSelectedItems()
    viewModel.changeEditing()
  }
}

// MARK: - Sorting
extension FullListViewController {

  @objc func sortMenu() {
    presentSortOptions(handler: sortMethod(action:))
  }

  @objc func sortMethod(action: UIAlertAction) {
    viewModel.sortBy(action.title!.lowercased())
    tableView.reloadData()
  }
}
