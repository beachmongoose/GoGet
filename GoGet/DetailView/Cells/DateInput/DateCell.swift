//
//  DateCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class DateCell: UITableViewCell {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var dateField: UITextField!
    var datePicker: UIDatePicker!

    var boughtStatusCell: SegmentedControlCell?
    var viewModel: DateCellViewModelType? {
        didSet { setupCell() }
    }
}

extension DateCell {
    func setupCell() {
        guard let viewModel = viewModel else { return }
        dateToggle()
        observeEnabled()
        dateLabel.text = viewModel.title
        dateField.text = viewModel.initialValue
        dateField.reactive.text.bind(to: viewModel.updatedValue)
        addDatePicker()
        selectionStyle = .none
    }

    func dateToggle() {
        guard let viewModel = viewModel else { return }
        dateField.isUserInteractionEnabled = viewModel.isEnabled.value
        dateField.textColor = (viewModel.isEnabled.value) ? UIColor.black : UIColor.gray
    }

    func observeEnabled() {
        viewModel?.isEnabled.observeNext { [ weak self] _ in
            self?.dateToggle()
        }
        .dispose(in: bag)
    }
}

// Formatting date
extension DateCell {
    func addDatePicker() {
        datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = UIDatePicker.Mode.date
        datePicker.transform = CGAffineTransform(scaleX: 275.0 / 350.0, y: 275.0 / 350.0)

        datePicker.addTarget(self, action: #selector(datePicked(sender:)),
                             for: UIControl.Event.valueChanged)
        dateField.inputView = datePicker
    }

    @objc func datePicked(sender: UIDatePicker) {
        dateField.text = sender.date.convertedToString()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true)
    }
}
