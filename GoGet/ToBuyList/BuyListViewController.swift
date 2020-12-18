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

class BuyListViewController: UIViewController, AlertPresenter {
    var alertController = UIAlertController()
    var selectAllButton: UIBarButtonItem!
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
        setUpAlerts()
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
                                                fatalError("Unable to dequeue BuyListCell") }
        let cellViewModel = dataSource[childAt: indexPath].item
        cell.viewModel = cellViewModel
        cell.checkButton.reactive.tapGesture().removeDuplicates().observeNext { [weak self] _ in
            self?.viewModel.selectDeselectIndex(indexPath)
        }
        .dispose(in: bag)
        cell.reactive.tapGesture().removeDuplicates().observeNext { [weak self] _ in
            self?.viewModel.presentDetail(for: indexPath)
        }
        .dispose(in: bag)
        return cell
    }
}

// MARK: - Navigation
extension BuyListViewController {
//TODO: ADJUST UI FOR SELECT ALL BUTTON
    func addNavigationButtons() {
//    selectAllButton = UIBarButtonItem(title: "Select All",
//                                      style: .plain,
//                                      target: nil,
//                                      action: nil)
//        selectAllButton.reactive.tap.bind(to: self) { $0.viewModel.}
        sortButton = UIBarButtonItem(title: "Sort",
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        sortButton.reactive.tap.bind(to: self) { $0.viewModel.presentSortOptions()}
        confirmButton = UIBarButtonItem(title: "Confirm",
                                        style: .plain,
                                        target: nil,
                                        action: nil)
        confirmButton.reactive.tap.bind(to: self) { guard $0.viewModel.itemsAreChecked.value else {
            $0.presentError(message: "No items selected.")
            return }
            $0.viewModel.presentBoughtAlert() }
        navigationItem.rightBarButtonItem = sortButton
        navigationItem.leftBarButtonItem = confirmButton

//        viewModel.itemsAreChecked.bind(to: self) { [weak self ] _, itemsAreChecked in
//            self?.navigationItem.leftBarButtonItem = (itemsAreChecked == true) ? self?.confirmButton : self?.selectAllButton
//        }
    }

    func setUpAlerts() {
        viewModel.alert.bind(to: self) { $0.show(alert: $1)}
    }

    func observeSelections() {
    }

//  func addAllToSelected() {
//    viewModel.selectAll()
//  }
}
