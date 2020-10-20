//
//  FullListCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol FullListCoordinatorType {
  func presentDetail(item: Item?)
  func start() -> UINavigationController
}

class FullListCoordinator: FullListCoordinatorType {
  weak var viewController: FullListViewController?

  private let getItems: GetItemsType

  init(getItems: GetItemsType = GetItems()) {
    self.getItems = getItems
  }

  func start() -> UINavigationController {
    let viewModel = FullListViewModel(coordinator: self)
    let viewController = FullListViewController(viewModel: viewModel)
    viewController.title = "Full List"
    self.viewController = viewController
    return UINavigationController(rootViewController: viewController)
  }

  func presentDetail(item: Item?) {
    let detailViewController = DetailViewCoordinator().start(item: item)

    guard let navigationController = viewController?.navigationController else {
      return
    }

    detailViewController.modalPresentationStyle = .fullScreen
    navigationController.pushViewController(detailViewController, animated: true)

  }
}
