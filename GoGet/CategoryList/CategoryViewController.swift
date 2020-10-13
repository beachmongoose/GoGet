//
//  CategoryListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/25/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

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
    setupTable()
    tableView.register(UINib(nibName: "CategoryListCell", bundle: nil), forCellReuseIdentifier: "CategoryListCell")
        super.viewDidLoad()
    }
}

extension CategoryViewController: UITableViewDelegate {
  func setupTable() {
    viewModel.tableData.bind(to: tableView) { dataSource, indexPath, tableView in
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell",
                                                     for: indexPath) as? CategoryListCell else {
        fatalError("Failed to populate Category Table")
      }
      let viewModel = dataSource[indexPath.row]
      cell.viewModel = viewModel
      return cell
    }
  }
}

extension CategoryViewController: UIGestureRecognizerDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if viewModel.tableData[indexPath.row].name != "--Select--" {
        self.dismiss(animated: true, completion: nil)
    } else {
      viewModel.changeSelectedIndex(to: indexPath.row)
      self.dismiss(animated: true, completion: nil)
    }
  }

  func changeButtonName(action: UIAlertAction, category: String?) {
    guard category != nil || category != "--Select--" else { presentError(message: "Name not entered.")
      return }
    if viewModel.isDuplicate(category!) { presentError(message: "Category already exists")}
  }
}
