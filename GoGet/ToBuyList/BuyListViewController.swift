//
//  ExpiredListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class BuyListViewController: UIViewController {
  var sortButton: UIBarButtonItem!
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
    addSortButton()
    setupTable()
    tableView.register(UINib(nibName: "BuyListCell", bundle: nil), forCellReuseIdentifier: "BuyListCell")
    super.viewDidLoad()
    }
}

// MARK: - Table Data
extension BuyListViewController: UITableViewDelegate {
  func setupTable() {
    let dataSource = SectionedTableViewBinderDataSource<BuyListViewModel.CellViewModel>(createCell: createCell)
    viewModel.tableData.bind(to: tableView, using: dataSource)
    tableView.delegate = self
  }

  // TODO: REPLACE LONG PRESS WITH CHECKBOX METHOD
  private func createCell(dataSource: Array2D<String, BuyListViewModel.CellViewModel>,
                          indexPath: IndexPath,
                          tableView: UITableView) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "BuyListCell",
                                                   for: indexPath) as? BuyListCell else {
                                                   fatalError("Unable to dequeue") }
    let cellViewModel = dataSource[childAt: indexPath].item
    cell.viewModel = cellViewModel
    cell.reactive.longPressGesture().removeDuplicates().observeNext { _ in
      self.viewModel.selectDeselectIndex(indexPath)
      self.presentBoughtAlert(handler: self.markAsBought(action:))
    }
    .dispose(in: cell.bag)
    return cell
  }

  @objc func markAsBought(action: UIAlertAction) {
    self.viewModel.markAsBought()
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.presentDetail(in: indexPath.section, for: indexPath.row)
  }
}

// MARK: - Sorting
extension BuyListViewController {

  func addSortButton() {
    sortButton = UIBarButtonItem(title: "Sort",
                                 style: .plain,
                                 target: nil,
                                 action: #selector(sortMenu))
    navigationItem.rightBarButtonItem = sortButton
  }

  @objc func sortMenu(sender: UIBarButtonItem) {
    presentSortOptions(handler: sortMethod(action:))
  }

  @objc func sortMethod(action: UIAlertAction) {
    viewModel.sortBy(action.title!.lowercased())
  }
}
