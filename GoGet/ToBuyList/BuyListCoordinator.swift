//
//  BuyListCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol BuyListCoordinatorType {
  func start() -> UINavigationController
  func presentDetail(_ item: Item)
}

class BuyListCoordinator: BuyListCoordinatorType {

  weak var viewController: BuyListViewController?
  var delete = false

  func start() -> UINavigationController {
    let viewModel = BuyListViewModel(coordinator: self)
    let viewController = BuyListViewController(viewModel: viewModel)
    viewController.title = "Buy List"
    self.viewController = viewController
    return UINavigationController(rootViewController: viewController)
  }

  func presentDetail(_ item: Item) {
    let detailViewController = DetailViewCoordinator().start(with: item)

    guard let navigationController = viewController?.navigationController else {
      return
    }

    detailViewController.modalPresentationStyle = .fullScreen
    navigationController.pushViewController(detailViewController, animated: true)
  }
}
