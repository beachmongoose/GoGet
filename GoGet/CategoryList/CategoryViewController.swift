//
//  CategoryListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/25/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class CategoryViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  private var viewModel: CategoryListViewModelType

  init(viewModel: CategoryListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func viewDidLoad() {
    tableView.tableFooterView = UIView()
    setupTable()
    super.viewDidLoad()
  }
}

extension CategoryViewController: UITableViewDelegate, UIGestureRecognizerDelegate {

  func setupTable() {
    tableView.register(UINib(nibName: "CategoryListCell", bundle: nil), forCellReuseIdentifier: "CategoryListCell")

    viewModel.tableData.bind(to: tableView) { dataSource, indexPath, tableView in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell",
                                                     for: indexPath) as? CategoryListCell else {
        fatalError("Failed to populate Category Table")
      }
      let viewModel = dataSource[indexPath.row]
      cell.viewModel = viewModel

      cell.reactive.tapGesture().observeNext { [weak self] _ in
        self?.viewModel.changeSelectedIndex(to: indexPath.row)
        self?.dismiss(animated: true, completion: nil)
      }
      .dispose(in: self.bag)
      cell.reactive.longPressGesture().observeNext { _ in
        self.viewModel.changeSelectedIndex(to: indexPath.row)
        self.presentDeleteAlert(handler: self.viewModel.deleteCategory(action:))
      }
      .dispose(in: cell.bag)

      return cell
    }
  }

  @objc func longPress(longPress: UILongPressGestureRecognizer) {
    if longPress.state == UIGestureRecognizer.State.began {
      let touchPoint = longPress.location(in: tableView)
      if let selectedItem = tableView.indexPathForRow(at: touchPoint) {
        viewModel.changeSelectedIndex(to: selectedItem.row)
        presentDeleteAlert(handler: viewModel.deleteCategory(action:))
      }
    }
  }
}

extension CategoryViewController {
  @IBAction func createNew(_ sender: Any) {
    addCategory(handler: checkName)
  }

  func checkName(action: UIAlertAction, category: String?) {
    guard category != nil || category != "None" else { presentError(message: "Name not entered.")
      return }
    if viewModel.isDuplicate(category!) { presentError(message: "Category already exists")}
    viewModel.createNewCategory(for: category!)
  }

  @IBAction func clearCategory(_ sender: Any) {
    viewModel.changeSelectedIndex(to: nil)
    dismiss(animated: true, completion: nil)
  }
}
