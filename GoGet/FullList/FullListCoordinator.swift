//
//  FullListCoordinator.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

protocol FullListCoordinatorType {
//  func start() -> FullListViewController
  func presentDetail(item: Item?)
  func dismiss()
}

class FullListCoordinator: FullListCoordinatorType {
  weak var viewController: FullListViewController?
  
  private let getItems: GetItemsType
  
  init(getItems: GetItemsType = GetItems()) {
    self.getItems = getItems
  }
  
  func start() -> FullListViewController {
    let viewModel = FullListViewModel(coordinator: self)
    let viewController = FullListViewController(viewModel: viewModel)
    self.viewController = viewController
    return viewController
  }
  
  func presentDetail(item: Item?) {
    guard let navigationController = viewController?.navigationController else { return }
    let detailViewController = DetailViewCoordinator().start(item: item)
    navigationController.pushViewController(detailViewController, animated: true)
  }
  
  func dismiss() {
    
  }
}