//
//  FullListCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol FullListCoordinatorType {
  func start() -> FullListViewController
  func presentDetailList()
  func dismiss()
}

class FullListCoordinator: FullListCoordinatorType {
  weak var viewController: FullListViewController?
  
  func start() -> FullListViewController {
    let viewController = FullListViewController()
    self.viewController = viewController
    return viewController
  }
  
  func presentDetailList() {
    guard let navigationController = viewController?.navigationController else { return }
    let detailViewController = DetailCoordinator().start()
    navigationController.pushViewController(detailViewController, animated: true)
  }
  
  func dismiss() {
    
  }
}
