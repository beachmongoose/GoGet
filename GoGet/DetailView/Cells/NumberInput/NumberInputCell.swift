//
//  NumberInputCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

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
            selectionStyle = .none
        label.text = viewModel?.title
        label2.text = viewModel?.title2
//            numberInputField.keyboardType = .numberPad
        //    durationInput.text = viewModel.duration.value
        //    durationInput.reactive.text.bind(to: viewModel.duration)
    }
}
