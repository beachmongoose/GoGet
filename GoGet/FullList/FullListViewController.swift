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
  @IBOutlet var tableView: UITableView!
  @IBOutlet var sortButton: UIButton!
  @IBOutlet var navigation: UINavigationBar!
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
      longPressDetector()
//      addMenuButton()
      tableView.register(UINib(nibName: "FullListCell", bundle: nil), forCellReuseIdentifier: "FullListCell")
      setupTable()
//      observeButtonEvents()
      super.viewDidLoad()
    }

  func observeButtonEvents() {
//    sortButton.reactive.tap.bind(to: self) { $0.viewModel.clear() }
  }
}

// MARK: - Populate Table
extension FullListViewController: UITableViewDelegate {
  func setupTable() {
    let dataSource =
      SectionedTableViewBinderDataSource<FullListViewModel.CellViewModel>(createCell: createCell)
    viewModel.tableData.bind(to: tableView, using: dataSource)
    tableView.delegate = self
  }
}

private func createCell(dataSource: Array2D<String, FullListViewModel.CellViewModel>,
                        indexPath: IndexPath,
                        tableView: UITableView) -> UITableViewCell {
  guard let cell = tableView.dequeueReusableCell(withIdentifier: "FullListCell",
                                                 for: indexPath) as? FullListCell else {
                                                 fatalError("Unable to Dequeue") }
        let cellViewModel = dataSource[childAt: indexPath].item
        cell.viewModel = cellViewModel
        return cell
}

// MARK: - Navigation
extension FullListViewController {
  override func viewWillLayoutSubviews() {
    let navigationBar = self.navigation
    self.view.addSubview(navigation)

    let navigationItem = UINavigationItem(title: "All Items")
    let menuButton = UIBarButtonItem(title: "Menu",
                                     style: .plain,
                                     target: self,
                                     action: #selector(menuPrompt))
    navigationItem.rightBarButtonItem = menuButton
    navigationBar!.setItems([navigationItem], animated: false)
  }

  @objc func menuPrompt() {
  }

  func MenuButton() -> UIBarButtonItem {
    let menu = UIBarButtonItem(
      title: "Menu",
      style: .plain,
      target: self,
      action: #selector(menuPrompt))
    return menu
  }

  func confirmAndCancelButtons() -> [UIBarButtonItem] {
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
    return [confirm, cancel]
  }
}

// MARK: - User Input
extension FullListViewController: UIGestureRecognizerDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      if !inDeleteMode {
        viewModel.editItem(indexPath)
      } else {
        viewModel.selectDeselectIndex(at: indexPath)
      }
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
        changeEditing(to: true)
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

  func changeEditing(to bool: Bool) {
    inDeleteMode = bool
    viewModel.clearIndex()
    tableView.allowsMultipleSelection = bool
    sortButton.isEnabled.toggle()
    if bool == false {
      longPressDetector()
      MenuButton()
    } else {
      confirmAndCancelButtons()
      view.gestureRecognizers?.removeAll()
    }
  }
}
