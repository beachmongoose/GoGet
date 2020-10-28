//
//  CategoryInputCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class CategoryInputCell: UITableViewCell {
  @IBOutlet var inputButton: UIButton!
  var viewModel: CategoryInputCellViewModelType? {
  didSet { setupCell() }
  }
}

extension CategoryInputCell {
  func setupCell() {
    selectionStyle = .none
//    categoryInput.setTitle(viewModel.selectedCategoryName.value, for: .normal)
//    viewModel.selectedCategoryName.observeNext { value in
//      let category = (value != nil) ? value: "None"
//      self.categoryInput.setTitle(category, for: .normal)
//    }
//    .dispose(in: bag)

    inputButton.backgroundColor = .clear
    inputButton.layer.cornerRadius = 5
    inputButton.layer.borderWidth = 0.25
    inputButton.layer.borderColor = UIColor.lightGray.cgColor
  }
}
//
//extension CategoryInputCell {
//
//  @IBAction func openCategories(_ sender: UIButton) {
//    viewModel?.presentPopover(sender: sender)
//  }
//
//  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//  return .none
//  }
//
//  func popoverPresentationControllerDidDismissPopover(
//    _ popoverPresentationController: UIPopoverPresentationController) {
//  }
//
//  func popoverPresentationControllerShouldDismissPopover(
//    _ popoverPresentationController: UIPopoverPresentationController) -> Bool {
//  return true
//  }
//}
