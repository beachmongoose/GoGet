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
  func presentFullList()
}

class BuyListCoordinator: BuyListCoordinatorType {
  weak var viewController: BuyListViewController?
  func start() -> UINavigationController {
    let viewController = BuyListViewController(coordinator: self)
    self.viewController = viewController
    return UINavigationController(rootViewController: viewController)
  }
  
  func presentFullList() {
    guard let navigationController = viewController?.navigationController else { return }
    let fullListViewController = FullListCoordinator().start()
    navigationController.pushViewController(fullListViewController, animated: true)
  }

}
