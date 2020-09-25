//
//  DetailViewCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol DetailViewCoordinatorType {
  func start(item: Item?) -> DetailViewController
  func errorMessage(_ message: String)
  func confirmSave()
  func dismissDetail(action: UIAlertAction)
}

class DetailViewCoordinator: DetailViewCoordinatorType {

  weak var viewController: DetailViewController?

  func start(item: Item?) -> DetailViewController {
    let viewModel = DetailViewModel(coordinator: self, item: nil)
    let viewController = DetailViewController(viewModel: viewModel)
    viewController.title = "New"
    self.viewController = viewController
    return viewController
  }

func dismissDetail(action: UIAlertAction) {
  viewController?.tabBarController?.selectedIndex = 0
  }

}

// MARK: - Alerts
extension DetailViewCoordinator {
  func errorMessage(_ message: String) {
      let errorAlert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
    errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    viewController?.present(errorAlert, animated: true)
    }

  func confirmSave() {
    let saveConfirm = UIAlertController(title: "Item Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: dismissDetail))
    viewController?.present(saveConfirm, animated: true)
  }
}
