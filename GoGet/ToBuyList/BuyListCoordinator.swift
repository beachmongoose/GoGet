//
//  BuyListCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol BuyListCoordinatorType {
  func start() -> BuyListViewController
  func presentFullList(completion: @escaping () -> Void)
  func presentDetail(_ item: Item, completion: @escaping () -> Void)
}

class BuyListCoordinator: BuyListCoordinatorType {

  weak var viewController: BuyListViewController?
  var delete = false

  func start() -> BuyListViewController {
    let viewModel = BuyListViewModel(coordinator: self)
    let viewController = BuyListViewController(viewModel: viewModel)
    viewController.title = "Buy List"
    self.viewController = viewController
    return viewController
  }

  func presentFullList(completion: @escaping () -> Void) {
    guard let navigationController = viewController?.navigationController else { return }
    let fullListViewController = FullListCoordinator().start()
    navigationController.pushViewController(fullListViewController, animated: true)
  }

  func presentDetail(_ item: Item, completion: @escaping () -> Void) {
  guard let navigationController = viewController?.navigationController else { return }
    let detailViewController = DetailViewCoordinator().start(item: item)
  navigationController.pushViewController(detailViewController, animated: true)
  }
}
