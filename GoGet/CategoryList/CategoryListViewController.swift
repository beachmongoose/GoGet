//
//  CategoryListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/25/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {
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
    tableView.register(UINib(nibName: "CategoryListCell", bundle: nil), forCellReuseIdentifier: "CategoryListCell")
    setupTable()
        super.viewDidLoad()
    }
}

extension CategoryListViewController: UITableViewDelegate {
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
