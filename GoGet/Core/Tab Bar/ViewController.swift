//
//  ViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/24/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class TabViewController: UITabBarController {
  let buyList: BuyListCoordinatorType = BuyListCoordinator()
  let fullList: FullListCoordinatorType = FullListCoordinator()
  
  weak var viewController: FullListViewController?

    override func viewDidLoad() {
      super.viewDidLoad()
      setupTabs()
    }
}

extension TabViewController {
  func setupTabs() {
    
    viewControllers = [
      buyList.start(),
      fullList.start(completion: () -> Void)
    ]
  }
}
