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
  func presentDetail(currentItem item: Item, newItem bool: Bool, index number: Int)
  func dismiss()
}

class FullListCoordinator: FullListCoordinatorType {
  weak var viewController: FullListViewController?
  
  func start() -> FullListViewController {
    let viewController = FullListViewController(coordinator: self)
    self.viewController = viewController
    return viewController
  }
  
  func presentDetail(currentItem item: Item, newItem bool: Bool, index number: Int) {
    guard let navigationController = viewController?.navigationController else { return }
    let detailViewController = DetailCoordinator().showDetailView()
    detailViewController.currentItem = item
    detailViewController.boughtDate = item.dateBought
    detailViewController.newItem = bool
    detailViewController.itemNumber = number
    navigationController.pushViewController(detailViewController, animated: true)
  }
  
  func dismiss() {
    
  }
}
