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
    var addNewButton: UIBarButtonItem!
    var noneButton: UIBarButtonItem!
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
        setUpTable()
        setUpNavigation()
        super.viewDidLoad()
    }
}

extension CategoryViewController: UITableViewDelegate, UIGestureRecognizerDelegate {

    func setUpTable() {
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
                self?.viewModel.changeSelectedCategory(for: indexPath.row)
                self?.dismiss(animated: true, completion: nil)
            }
            .dispose(in: self.bag)
            cell.reactive.longPressGesture().observeNext { _ in
                self.viewModel.changeSelectedIndex(to: indexPath.row)
                self.presentCategoryOptions(handler: self.categoryOptions)
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
                presentCategoryOptions(handler: categoryOptions)
            }
        }
    }

    func categoryOptions(action: UIAlertAction, option: SelectedOption) {
        switch option {
        case .rename:
            addCategory(handler: viewModel.renameCategory)
        case .delete:
            presentDeleteAlert(handler: viewModel.deleteCategory)
        }
    }
}

extension CategoryViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
    }

    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
}

extension CategoryViewController {
    func setUpNavigation() {
        noneButton = UIBarButtonItem(title: "None",
                                     style: .plain,
                                     target: self,
                                     action: nil)
        noneButton.reactive.tap.bind(to: self) {$0.clearCategory()}

        addNewButton = UIBarButtonItem(title: "Add New",
                                       style: .plain,
                                       target: self,
                                       action: nil)
        addNewButton.reactive.tap.bind(to: self) { $0.addCategory(handler: self.checkName)}
        navigationItem.rightBarButtonItem = noneButton
        navigationItem.leftBarButtonItem = addNewButton
    }

    func clearCategory() {
        viewModel.changeSelectedIndex(to: nil)
        viewModel.changeSelectedCategory(for: nil)
        dismiss(animated: true, completion: nil)
    }

    func checkName(action: UIAlertAction, category: String?) {
        guard category != nil || category != "None" else { presentError(message: "Name not entered.")
            return }
        if viewModel.isDuplicate(category!) { presentError(message: "Category already exists")}
        viewModel.createNewCategory(for: category!)
    }
}
