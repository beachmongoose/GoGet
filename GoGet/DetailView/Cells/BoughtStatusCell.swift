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

class BoughtStatusCell: UITableViewCell {
  @IBOutlet var boughtStatus: UISegmentedControl!

  var viewModel: DetailViewModel? {
  didSet { setupCell() }
  }
}

extension BoughtStatusCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    boughtStatus.selectedSegmentIndex = viewModel.bought.value ?? 1
    boughtStatus.reactive.selectedSegmentIndex.bind(to: viewModel.bought)
  }
}
