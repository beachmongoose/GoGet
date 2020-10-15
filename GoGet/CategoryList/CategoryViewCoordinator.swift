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
  func start(selectedIndex: Property<Int?>) -> CategoryViewController
}

class CategoryViewCoordinator: CategoryViewCoordinatorType {

  weak var viewController: CategoryViewController?

  func start(selectedIndex: Property<Int?>) -> CategoryViewController {
    let viewModel = CategoryViewModel(coordinator: self, selectedIndex: selectedIndex)
    let viewController = CategoryViewController(viewModel: viewModel)
    return viewController
  }
}
