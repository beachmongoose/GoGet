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
  func start() -> UINavigationController
  func start(with item: Item) -> UIViewController
  func errorMessage(_ message: String)
  func confirmSave(_ item: Bool)
  func dismissDetail(action: UIAlertAction)
  func presentPopover(sender: UIButton, selectedID: Property<String?>)
}

class DetailViewCoordinator: DetailViewCoordinatorType {
  weak var viewController: DetailViewController?

  func start() -> UINavigationController {
    let viewModel = DetailViewModel(coordinator: self, item: nil)
    let viewController = DetailViewController(viewModel: viewModel)
    viewController.title = "New Item"
    self.viewController = viewController
    return UINavigationController(rootViewController: viewController)
  }

  func start(with item: Item) -> UIViewController {
    let viewModel = DetailViewModel(coordinator: self, item: item)
    let viewController = DetailViewController(viewModel: viewModel)
    viewController.title = "Edit Item"
    self.viewController = viewController
    return viewController
  }

  func dismissDetail(action: UIAlertAction) {
    viewController?.clearInput()
    viewController?.tabBarController?.selectedIndex = 2
  }

  func popController(action: UIAlertAction) {
    guard let navigationController = viewController?.navigationController else {
      return
    }
    navigationController.popViewController(animated: true)
  }

  func presentPopover(sender: UIButton, selectedID: Property<String?>) {
    guard let viewController = viewController else { return }

    let categoryController = CategoryViewCoordinator().start(selectedID: selectedID)
    categoryController.preferredContentSize = CGSize(width: 300, height: 250)
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

  func confirmSave(_ item: Bool) {
    let handler = (item) ? dismissDetail(action:) : popController(action:)
    let saveConfirm = UIAlertController(title: "Item Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
    viewController?.present(saveConfirm, animated: true)
  }
}
