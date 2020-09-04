//
//  DetailViewCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol DetailCoordinatorType {
  func showDetailView() -> DetailViewController
  func dismissDetail()
}

class DetailCoordinator: DetailCoordinatorType {
  
  weak var viewController: DetailViewController?
  
  func showDetailView() -> DetailViewController {
    let viewController = DetailViewController(coordinator: self)
    self.viewController = viewController
    return viewController
  }
  
  func dismissDetail() {
    guard let navigationController = viewController?.navigationController else { return }
    navigationController.popViewController(animated: true)
  }
}
