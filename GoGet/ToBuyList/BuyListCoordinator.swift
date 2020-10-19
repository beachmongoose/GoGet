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
  func presentDetail(_ item: Item)
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

  func presentDetail(_ item: Item) {
    let detailController = DetailViewCoordinator().start(item: item)
    viewController?.tabBarController!.present(detailController, animated: true)
  }
}
