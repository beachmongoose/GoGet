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

enum ItemStatus {
    case newItem
    case editItem
}

protocol DetailViewCoordinatorType {
    func start() -> UINavigationController
    func start(with item: Item) -> UIViewController
    func confirmSaveEdit()
    func confirmSaveNew()
    func dismissFromNew(action: UIAlertAction)
    func dismissFromEdit(action: UIAlertAction)
    func presentPopover(indexPath: IndexPath, dimensions: CGRect, selectedID: Property<String?>)
}

class DetailViewCoordinator: DetailViewCoordinatorType {

    weak var viewController: DetailViewController?

// New Item
    func start() -> UINavigationController {
        let viewModel = NewDetailViewModel(coordinator: self)
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.title = "New Item"
        self.viewController = viewController
        return UINavigationController(rootViewController: viewController)
  }

// Edit Item
    func start(with item: Item) -> UIViewController {
        let viewModel = DetailViewModel(coordinator: self, item: item)
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.title = "Edit Item"
        self.viewController = viewController
        return viewController
  }

// MARK: - Dismissal
    func dismissFromNew(action: UIAlertAction) {
        viewController?.clearInput()
        viewController?.tabBarController?.selectedIndex = 2
    }

    func dismissFromEdit(action: UIAlertAction) {
        guard let navigationController = viewController?.navigationController else {
            return
        }
        navigationController.popViewController(animated: true)
    }

// MARK: - Category List
    func presentPopover(indexPath: IndexPath, dimensions: CGRect, selectedID: Property<String?>) {
        guard let viewController = viewController else { return }

        let categoryController = CategoryViewCoordinator().start(selectedID: selectedID)
        categoryController.modalPresentationStyle = .popover
        if let presentationController = categoryController.popoverPresentationController {
            presentationController.permittedArrowDirections = .up
            presentationController.sourceView = viewController.view
            presentationController.sourceRect = dimensions
            presentationController.delegate = viewController.self
            viewController.present(categoryController, animated: true, completion: nil)
        }
    }
}

// MARK: - Alerts
extension DetailViewCoordinator {
    func confirmSaveNew() {
        let saveConfirm = confirmAlert(for: .newItem)
        viewController?.present(saveConfirm, animated: true)
    }

    func confirmSaveEdit() {
        let saveConfirm = confirmAlert(for: .editItem)
        viewController?.present(saveConfirm, animated: true)
    }

    func confirmAlert(for item: ItemStatus) -> UIAlertController {
        let handler = (item == .newItem) ? dismissFromNew : dismissFromEdit
        let saveConfirm = UIAlertController(title: "Item Saved", message: nil, preferredStyle: .alert)
        saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: handler))
        return saveConfirm
    }
}
