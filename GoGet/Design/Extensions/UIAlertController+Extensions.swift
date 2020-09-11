//
//  UIAlertController+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

extension UIAlertController {
  func withSortOptions(handler: (((UIAlertAction) -> Void)?)) -> UIAlertController {
    title = "Sort by..."
    addAction(UIAlertAction(title: "Name", style: .default, handler: handler))
    addAction(UIAlertAction(title: "Date", style: .default, handler: handler))
    addAction(UIAlertAction(title: "Added", style: .default, handler: handler))
    addAction(UIAlertAction(title: "Cancel", style: .cancel))
    return self
  }
  
//  func deletePrompt(handler: ((UIAlertAction) -> Void)?) -> UIAlertController {
//    title = "Delete Item?"
//    addAction(UIAlertAction(title: "Yes", style: .default, handler: handler))
//    addAction(UIAlertAction(title: "No", style: .cancel))
//    return self
//  }
  
}
