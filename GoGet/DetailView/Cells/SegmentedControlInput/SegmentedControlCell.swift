//
//  SegmentedControlCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/29/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class SegmentedControlCell: UITableViewCell {
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var boughtSegment: UISegmentedControl!
  var viewModel: SegmentedControlCellViewModelType? {
        didSet { setupCell() }
  }
}

extension SegmentedControlCell {
    func setupCell() {
        selectionStyle = .none
        initialValue()
        observeBoughtUpdate()
    }

  func initialValue() {
    guard let viewModel = viewModel else { return }
    let int = (viewModel.initialValue) ? 0 : 1
    boughtSegment.selectedSegmentIndex = (int)
    }

    func observeBoughtUpdate() {
        boughtSegment.reactive.selectedSegmentIndex.observeNext { [ weak self ] value in
            let bool = (self?.boughtSegment.selectedSegmentIndex == 0)
            self?.viewModel?.updatedValue.value = bool
        }
        .dispose(in: bag)
    }
}
