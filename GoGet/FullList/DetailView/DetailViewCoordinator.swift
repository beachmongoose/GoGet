//
//  DetailViewCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol DetailCoordinatorType {
  func start() -> DetailViewController
  func dismissDetailList()
}

class DetailCoordinator: DetailCoordinatorType {
  weak var viewController: DetailViewController?
  
  func start() -> DetailViewController {
    let viewController = DetailViewController()
    self.viewController = viewController
    return viewController
  }
  
  func dismissDetailList() {
    viewController?.dismiss(animated: true)
  }
}
