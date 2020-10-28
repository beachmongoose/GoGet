//
//  TitleCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class TextInputCell: UITableViewCell {
  @IBOutlet var inputField: UITextField!
  var viewModel: TextInputCellViewModelType? {
  didSet { setupCell() }
  }
}

extension TextInputCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    inputField.text = viewModel.initialValue
    inputField.reactive.text.bind(to: viewModel.updatedValue)
    selectionStyle = .none
  }
}
