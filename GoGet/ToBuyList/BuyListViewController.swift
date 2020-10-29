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
  var confirmButton: UIBarButtonItem!
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
    addNavigationButtons()
    setupTable()
    tableView.register(UINib(nibName: "BuyListCell", bundle: nil), forCellReuseIdentifier: "BuyListCell")
    super.viewDidLoad()
    }
}

// MARK: - Table Data
extension BuyListViewController: UITableViewDelegate {
  func setupTable() {
    let dataSource = SectionedTableViewBinderDataSource<BuyListCellViewModel>(createCell: createCell)
    viewModel.tableData.bind(to: tableView, using: dataSource)
    tableView.delegate = self
    tableView.tableFooterView = UIView()
  }

  private func createCell(dataSource: Array2D<String, BuyListCellViewModel>,
                          indexPath: IndexPath,
                          tableView: UITableView) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "BuyListCell",
                                                   for: indexPath) as? BuyListCell else {
                                                   fatalError("Unable to dequeue") }
    let cellViewModel = dataSource[childAt: indexPath].item
    cell.viewModel = cellViewModel
    cell.checkButton.reactive.tapGesture().removeDuplicates().observeNext { [weak self] _ in
      self?.viewModel.selectDeselectIndex(indexPath)
    }
    .dispose(in: bag)
    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    viewModel.presentDetail(in: indexPath.section, for: indexPath.row)
  }
}

// MARK: - Navigation
extension BuyListViewController {

  func addNavigationButtons() {
    sortButton = UIBarButtonItem(title: "Sort",
                                 style: .plain,
                                 target: nil,
                                 action: nil)
    sortButton.reactive.tap.bind(to: self) { $0.presentSortOptions(handler: self.sortMethod(action:))}
    confirmButton = UIBarButtonItem(title: "Move",
                                    style: .plain,
                                    target: nil,
                                    action: nil)
    confirmButton.reactive.tap.bind(to: self) { guard $0.viewModel.itemsAreChecked else {
      $0.presentError(message: "No items selected.")
      return }
      self.presentBoughtAlert(handler: self.markAsBought(action:)) }
    navigationItem.rightBarButtonItem = sortButton
    navigationItem.leftBarButtonItem = confirmButton
  }

  @objc func sortMethod(action: UIAlertAction) {
    viewModel.sortBy(action.title!.lowercased())
  }

  @objc func markAsBought(action: UIAlertAction) {
    self.viewModel.markAsBought()
  }
}
