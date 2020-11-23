//
//  CategoryListViewCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/30/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import ReactiveKit
import UIKit

protocol CategoryListViewCoordinatorType {
    func start(selectedID: Property<String?>) -> UINavigationController
    func nameError(message: String)
}

class CategoryListViewCoordinator: CategoryListViewCoordinatorType {

    weak var viewController: CategoryListViewController?

    func start(selectedID: Property<String?>) -> UINavigationController {
        let viewModel = CategoryListViewModel(coordinator: self, selectedID: selectedID)
        let viewController = CategoryListViewController(viewModel: viewModel)
        viewController.title = "Categories"
        self.viewController = viewController
        return UINavigationController(rootViewController: viewController)
    }

    func nameError(message: String) {
        let errorAlert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        viewController?.present(errorAlert, animated: true)
    }
}
