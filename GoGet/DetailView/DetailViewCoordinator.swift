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
  func dismissDetail()
}

class DetailViewCoordinator: DetailViewCoordinatorType {
  
  weak var viewController: DetailViewController?
  
  func start(item: Item?) -> DetailViewController {
    let viewModel = DetailViewModel(coordinator: self, item: item)
    let viewController = DetailViewController(viewModel: viewModel)
    self.viewController = viewController
    return viewController
  }
  
  func errorMessage() -> UIAlertController {
      let dateError = UIAlertController(title: "Error", message: "Future date selected", preferredStyle: .alert)
    dateError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    return dateError
//      present(dateError, animated: true)
    }
  
//  func confirmSave() -> UIAlertController {
//    let saveConfirm = UIAlertController(title: "Item Saved", message: nil, preferredStyle: .alert)
//    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
//        viewModel.dismissDetail()
//    }))
//    return saveConfirm
//  }
  
  func dismissDetail() {
    guard let navigationController = viewController?.navigationController else { return }
    navigationController.popViewController(animated: true)
  }

}
