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
  func presentFullList(completion: @escaping () -> Void)
}

class BuyListCoordinator: BuyListCoordinatorType {
  
  weak var viewController: BuyListViewController?
  var delete = false
  
  func start() -> UINavigationController {
    let viewModel = BuyListViewModel(coordinator: self)
    let viewController = BuyListViewController(viewModel: viewModel)
    self.viewController = viewController
    return UINavigationController(rootViewController: viewController)
  }
  
  func presentFullList(completion: @escaping () -> Void) {
    guard let navigationController = viewController?.navigationController else { return }
    let fullListViewController = FullListCoordinator().start(completion: completion)
    navigationController.pushViewController(fullListViewController, animated: true)
  }

//  func deletePrompt(){
//    let deletePrompt = UIAlertController(title: "Mark as Bought?", message: nil, preferredStyle: .alert)
//    deletePrompt.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
//      self.delete = true
//    }))
//    deletePrompt.addAction(UIAlertAction(title: "No", style: .default, handler: { action in
//      self.delete = false
//    }))
//    viewController?.present(deletePrompt, animated: true)
//  }
  
}
