//
//  NumberInputCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import ReactiveKit
import UIKit

class NumberInputCell: UITableViewCell {
    @IBOutlet var numberInputField: UITextField!
    @IBOutlet var label: UILabel!
    @IBOutlet var label2: UILabel!
    var viewModel: NumberInputCellViewModelType? {
        didSet { setupCell() }
    }
}

extension NumberInputCell {
    func setupCell() {
        guard let viewModel = viewModel else { return }
        numberInputField.text = viewModel.initialValue
        label.text = viewModel.title
        label2.text = viewModel.title2
        selectionStyle = .none
        numberInputField.keyboardType = .numberPad
        numberInputField.reactive.text.bind(to: viewModel.updatedValue)
    }
}
