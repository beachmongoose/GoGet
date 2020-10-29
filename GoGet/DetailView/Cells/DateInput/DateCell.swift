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

  var boughtStatusCell: SegmentedControlCell?
  var viewModel: DateCellViewModelType? {
    didSet { setupCell() }
  }
}

extension DateCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    dateField.isUserInteractionEnabled = viewModel.isEnabled
    dateField.textColor = (viewModel.isEnabled) ? UIColor.black : UIColor.gray
    dateLabel.text = viewModel.title
    dateField.text = viewModel.initialValue
    dateField.reactive.text.bind(to: viewModel.updatedValue)
    addDatePicker()
    selectionStyle = .none
  }
}

// Formatting date
extension DateCell {
  func addDatePicker() {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = UIDatePicker.Mode.date

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
