//
//  CategoryInputCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class CategoryInputCell: UITableViewCell, UIPopoverPresentationControllerDelegate {
    @IBOutlet var inputButton: UIButton!
    @IBOutlet var categoryLabel: UILabel!
    var viewModel: CategoryInputCellViewModelType? {
        didSet { setupCell() }
    }
}

extension CategoryInputCell {
    func setupCell() {
        guard let viewModel = viewModel else { return }
        categoryLabel.text = viewModel.title
        inputButton.setTitle(viewModel.selectedCategoryName.value, for: .normal)
        viewModel.selectedCategoryName.observeNext { category in
            self.inputButton.setTitle(category, for: .normal)
        }
        .dispose(in: bag)
        inputButton.backgroundColor = .clear
        inputButton.layer.cornerRadius = 5
        inputButton.layer.borderWidth = 0.25
        inputButton.layer.borderColor = UIColor.lightGray.cgColor
        selectionStyle = .none
    }
}

extension CategoryInputCell {

//  @IBAction func openCategories(_ sender: UIButton) {
//    viewModel?.presentPopover(sender: sender)
//  }

//    func popover() {
//        inputButton.reactive.tap.observeNext { _ in
//            guard let viewModel = self.viewModel else { return }
//            let index = viewModel.selectedCategoryIndex
//            let categoryController = CategoryViewCoordinator().start(selectedIndex: index)
//            categoryController.preferredContentSize = CGSize(width: 300, height: 250)
//            categoryController.modalPresentationStyle = .popover
//            if let presentationController = categoryController.popoverPresentationController {
//                presentationController.sourceView = self.inputButton
//                presentationController.sourceRect = self.inputButton.bounds
//                presentationController.delegate =
//                viewController.present(categoryController, animated: true, completion: nil)
//              }
//        }
//        .dispose(in: bag)
//    }
    func adaptivePresentationStyle(for controller: UIPresentationController) ->     UIModalPresentationStyle {
    return .none
    }
    func popoverPresentationControllerDidDismissPopover(
    _ popoverPresentationController: UIPopoverPresentationController) {
    }
    func popoverPresentationControllerShouldDismissPopover(
    _ popoverPresentationController: UIPopoverPresentationController) -> Bool {
    return true
    }
}
