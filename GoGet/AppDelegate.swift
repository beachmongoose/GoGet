//
//  AppDelegate.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  override convenience init() {
    let window = UIWindow(frame: UIScreen.main.bounds)
    self.init(window: window)
  }
  init(window: UIWindow) {
    self.window = window
  }

  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let viewController = BuyListCoordinator().start()
    window?.makeKeyAndVisible()

    window?.rootViewController = viewController
    return true
  }

}
