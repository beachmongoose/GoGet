//
//  DetailViewCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

protocol DetailViewCoordinatorType {
  func start(item: Item?) -> DetailViewController
  func errorMessage(_ message: String)
  func confirmSave()
  func dismissDetail(action: UIAlertAction)
  func presentPopover(sender: UIButton, selectedIndex: Property<Int?>)
}

class DetailViewCoordinator: DetailViewCoordinatorType {

  weak var viewController: DetailViewController?

  func start(item: Item?) -> DetailViewController {
    let viewModel = DetailViewModel(coordinator: self, item: item)
    let viewController = DetailViewController(viewModel: viewModel)
    viewController.title = "New Item"
    self.viewController = viewController
    return viewController
  }

func dismissDetail(action: UIAlertAction) {
  viewController?.tabBarController?.selectedIndex = 0
  }

  func presentPopover(sender: UIButton, selectedIndex: Property<Int?>) {
    guard let viewController = viewController else { return }

    let categoryController = CategoryViewCoordinator().start(selectedIndex: selectedIndex)
    categoryController.modalPresentationStyle = .popover
    if let presentationController = categoryController.popoverPresentationController {
      presentationController.sourceView = sender
      presentationController.sourceRect = sender.bounds
      presentationController.delegate = viewController.self
      viewController.present(categoryController, animated: true, completion: nil)
    }
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
