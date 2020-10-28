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
  @IBOutlet var dateInput: UITextField!

  var boughtStatusCell: SegmentedControllCell?
  var viewModel: DateCellViewModelType? {
    didSet { setupCell() }
  }
}

extension DateCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    dateInput.text = viewModel.initialValue
    dateInput.reactive.text.bind(to: viewModel.updatedValue)
    boughtToggle()
    selectionStyle = .none
  }
}

// Toggle access
extension DateCell {
  func boughtToggle() {
    boughtStatusCell?.boughtStatus.reactive.selectedSegmentIndex.observeNext { [weak self] _ in
      switch self?.boughtStatusCell?.boughtStatus.selectedSegmentIndex {
      case 0:
      self?.boughtFieldEnable(true)
      case 1:
      self?.boughtFieldEnable(false)
      default:
      break
      }
    }
    .dispose(in: bag)
  }

  func boughtFieldEnable(_ bool: Bool) {
    dateInput.isUserInteractionEnabled = bool
    dateInput.textColor = (bool) ? UIColor.black : UIColor.gray
    print("toggled")
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
    dateInput.inputView = datePicker
  }

  @objc func datePicked(sender: UIDatePicker) {
    dateInput.text = sender.date.convertedToString()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.endEditing(true)
  }
}
