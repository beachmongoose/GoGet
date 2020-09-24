//
//  ViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/24/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
  let buyView: BuyListCoordinatorType = BuyListCoordinator()
  let fullView: FullListCoordinatorType = FullListCoordinator()
  let detailView: DetailViewCoordinatorType = DetailViewCoordinator()

  weak var viewController: FullListViewController?

    override func viewDidLoad() {
      super.viewDidLoad()
      setupTabs()
    }
}

extension TabViewController {
  func setupTabs() {

    viewControllers = [
      buyView.start(),
      detailView.start(item: nil),
      fullView.start()
    ]
  }
}
