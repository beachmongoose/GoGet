//
//  BuyListCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class BuyListCell: UITableViewCell {
  @IBOutlet var item: UILabel!
  @IBOutlet var dateBought: UILabel!

  var viewModel: BuyListViewModel.CellViewModel? {
    didSet { setupCell() }
  }
}

extension BuyListCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    item.text = "\(viewModel.name) (\(viewModel.quantity))"
    dateBought.text = viewModel.buyData
  }
}
