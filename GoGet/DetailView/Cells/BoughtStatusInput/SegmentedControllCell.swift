//
//  BoughtStatusCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class SegmentedControllCell: UITableViewCell {
  @IBOutlet var boughtStatus: UISegmentedControl!

  var viewModel: SegmentedControlCellViewModelType? {
  didSet { setupCell() }
  }
}

extension SegmentedControllCell {
  func setupCell() {
    selectionStyle = .none
    guard let viewModel = viewModel else { return }
    boughtStatus.selectedSegmentIndex = viewModel.initialValue
    boughtStatus.reactive.selectedSegmentIndex.bind(to: viewModel.updatedValue)
  }
}
