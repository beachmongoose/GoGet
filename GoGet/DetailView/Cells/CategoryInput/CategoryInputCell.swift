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
    override func awakeFromNib() {
        inputButton.backgroundColor = .clear
        inputButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        inputButton.layer.cornerRadius = 5
        inputButton.layer.borderWidth = 0.25
        inputButton.layer.borderColor = UIColor.lightGray.cgColor
        selectionStyle = .none
    }
}

extension CategoryInputCell {
    func setupCell() {
        guard let viewModel = viewModel else { return }
        categoryLabel.text = viewModel.title
        inputButton.setTitle(viewModel.selectedCategoryName.value, for: .normal)
        viewModel.selectedCategoryName.observeNext { [weak self] category in
            self?.inputButton.setTitle(category, for: .normal)
        }
        .dispose(in: bag)
    }
}
