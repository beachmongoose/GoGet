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
  @IBOutlet var tableView: UITableView!
  @IBOutlet var navigation: UINavigationBar!
  private let viewModel: BuyListViewModelType

  init(viewModel: BuyListViewModelType) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    longPressDetector()
    setupTable()
    tableView.register(UINib(nibName: "BuyListCell", bundle: nil), forCellReuseIdentifier: "BuyListCell")
    super.viewDidLoad()
    }
}

// MARK: - Populate Table
extension BuyListViewController: UITableViewDelegate {
  func setupTable() {
    let dataSource = SectionedTableViewBinderDataSource<BuyListViewModel.CellViewModel>(createCell: createCell)
    viewModel.tableData.bind(to: tableView, using: dataSource)
    tableView.delegate = self
  }
  private func createCell(dataSource: Array2D<String, BuyListViewModel.CellViewModel>,
                          indexPath: IndexPath,
                          tableView: UITableView) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "BuyListCell",
                                                   for: indexPath) as? BuyListCell else {
                                                   fatalError("Unable to dequeue") }
    let cellViewModel = dataSource[childAt: indexPath].item
    cell.viewModel = cellViewModel
    return cell
  }
}

// MARK: - Change State
extension BuyListViewController {
  func longPressDetector() {
    let longPressDetector = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
    view.addGestureRecognizer(longPressDetector)
  }

  @objc func longPress(longPress: UILongPressGestureRecognizer) {
    if longPress.state == UIGestureRecognizer.State.began {
      let touchPoint = longPress.location(in: tableView)
      if let selectedItem = tableView.indexPathForRow(at: touchPoint) {
        viewModel.selectDeselectIndex(selectedItem)
        changeStatePrompt()
      }
    }
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    viewModel.presentDetail(in section: indexPath.section, for row: indexPath.row)
    self.tableView.reloadData()
  }

  func changeStatePrompt() {
    presentBoughtAlert(handler: markAsBought(action:))
  }

  @objc func markAsBought(action: UIAlertAction) {
    self.viewModel.markAsBought()
    self.tableView.reloadData()
  }
}

// MARK: - Navigation
extension BuyListViewController {
  override func viewWillLayoutSubviews() {
    let navigationBar = self.navigation
    self.view.addSubview(navigation)

    let navigationItem = UINavigationItem(title: "GoGet")
    let menuButton = UIBarButtonItem(title: "Menu",
                                     style: .plain,
                                     target: self,
                                     action: #selector(menuPrompt))
    navigationItem.rightBarButtonItem = menuButton
    navigationBar!.setItems([navigationItem], animated: false)
  }

  @objc func menuPrompt() {
  }
}

  // MARK: - Sorting
  extension BuyListViewController {
    @IBAction func sortButton(_ sender: Any) {
      presentSortOptions(handler: sortMethod(action:))
      }

    @objc func sortMethod(action: UIAlertAction) {
      viewModel.sortBy(action.title!.lowercased())
      tableView.reloadData()
      }
  }

// MARK: - Data Handling
  extension BuyListViewController {
  @objc func presentFullList() {
    viewModel.presentFullList()
  }

  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
}
