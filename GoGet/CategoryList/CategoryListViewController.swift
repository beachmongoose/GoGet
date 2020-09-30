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
    setupTable()
        super.viewDidLoad()
    }
}

extension CategoryListViewController: UITableViewDelegate {
  func setupTable() {
    let dataSource = SectionedTableViewBinderDataSource<String>(createCell: createCell)
    viewModel.tableData.bind(to: tableView, using: dataSoruce)
    tableView.delegate = self
  }
}

private func createCell(dataSource: Array<String>) -> UITableViewCell {
  guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListCell", for: indexPath) as? CategoryListCell else {
    fatalError("Unable to Dequeue Category List Cell") }
  let cellModel = dataSource(childAt: indexPath)
  cell.viewModel = cellModel
  return cell
  }
}
