//
//  FullListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit
import UIKit

class FullListViewController: UIViewController, AlertPresenter {
    var alertController = UIAlertController()
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
        setUpAlerts()
        observeEditModeUpdates()
        super.viewDidLoad()
    }
}

// MARK: - View Setup
extension FullListViewController: UITableViewDelegate {
    func setupTable() {
        tableView.register(UINib(nibName: "FullListCell", bundle: nil), forCellReuseIdentifier: "FullListCell")
        let dataSource =
            SectionedTableViewBinderDataSource<FullListCellViewModel>(createCell: createCell)
        viewModel.tableData.bind(to: tableView, using: dataSource)
        tableView.delegate = self
        tableView.tableFooterView = UIView()
    }

    private func createCell(dataSource: Array2D<String, FullListCellViewModel>,
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
        cell.reactive.longPressGesture().removeDuplicates().observeNext { [weak self] _ in
            self?.viewModel.selectDeselectIndex(at: indexPath)
            self?.viewModel.changeEditing()
        }
        .dispose(in: cell.bag)
        return cell
    }
}
// MARK: - Navigation
extension FullListViewController {

    func setupNavigationBar() {
//        sortButton = UIBarButtonItem(title: "Sort",
//                                     style: .plain,
//                                     target: nil,
//                                     action: nil)
//        sortButton.reactive.tap.bind(to: self) { $0.presentSortOptions(handler: $0.sortMethod(action:)) }
        sortButton = UIBarButtonItem(title: "Sort",
                                     style: .plain,
                                     target: nil,
                                     action: nil)
        sortButton.reactive.tap.bind(to: self) { $0.viewModel.presentSortOptions() }
        confirmButton = UIBarButtonItem(title: "Delete",
                                        style: .plain,
                                        target: self,
                                        action: nil)
        confirmButton.reactive.tap.bind(to: self) { $0.presentConfirmRequest(handler: $0.removeItems(action:))}
        cancelButton = UIBarButtonItem(title: "Cancel",
                                       style: .plain,
                                       target: self,
                                       action: nil)
        cancelButton.reactive.tap.bind(to: self) {
            $0.viewModel.changeEditing() }
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
        viewModel.inDeleteMode.removeDuplicates().observeNext { [weak self] deleteMode in
            self?.tableView.allowsMultipleSelection = deleteMode
            if !deleteMode {
                self?.viewModel.clearSelectedItems()
                self?.addSortButton()
            } else {
                self?.confirmAndCancelButtons()
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

    @objc func removeItems(action: UIAlertAction) {
        viewModel.removeItems()
        viewModel.changeEditing()
    }

    @objc func sortMethod(action: UIAlertAction) {
        viewModel.sortBy(action.title!.lowercased())
        tableView.reloadData()
    }

    func setUpAlerts() {
        viewModel.alert.bind(to: self) { $0.show(alert: $1)}
    }
}
