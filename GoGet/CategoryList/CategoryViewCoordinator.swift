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

protocol CategoryViewCoordinatorType {
    func start(selectedID: Property<String?>) -> CategoryViewController
}

class CategoryViewCoordinator: CategoryViewCoordinatorType {

    weak var viewController: CategoryViewController?

    func start(selectedID: Property<String?>) -> CategoryViewController {
        let viewModel = CategoryViewModel(coordinator: self, selectedID: selectedID)
        let viewController = CategoryViewController(viewModel: viewModel)
        return viewController
    }
}
