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

  var viewModel: DetailViewModel?
  var boughtStatusCell: BoughtStatusCell? {
    didSet { setupCell()
//      addDatePicker()
      boughtToggle()
    }
  }
}

extension DateCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    dateInput.text = viewModel.dateBought.value
    dateInput.reactive.text.bind(to: viewModel.dateBought)
  }
}

// Toggle access
extension DateCell {
  func boughtToggle() {
    boughtStatusCell?.boughtStatus.reactive.selectedSegmentIndex.observeNext { [weak self] _ in
      switch self?.viewModel?.bought.value {
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
  }
}

// Formatting date
//extension DateCell {
//  func addDatePicker() {
//    let datePicker = UIDatePicker()
//    datePicker.preferredDatePickerStyle = .wheels
//    datePicker.datePickerMode = UIDatePicker.Mode.date
//
//    datePicker.addTarget(self, action: #selector(DetailViewController.datePicked(sender:)),
//                         for: UIControl.Event.valueChanged)
//    dateInput.inputView = datePicker
//  }
//
//  @objc func datePicked(sender: UIDatePicker) {
//    dateInput.text = viewModel?.convertedDate(sender.date)
//  }
//
//  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//    self.endEditing(true)
//  }
//}
