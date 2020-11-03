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
