//
//  BuyListCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

class BuyListCell: UITableViewCell {
  @IBOutlet var item: UILabel!
  @IBOutlet var dateBought: UILabel!
  @IBOutlet var checkButton: UIButton!
  public var onTapped: (() -> Void)?

  var viewModel: BuyListCellViewModel? {
    didSet {
      setupCell()
    }
  }
}

extension BuyListCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    item.text = "\(viewModel.name) (\(viewModel.quantity))"
    dateBought.text = viewModel.buyData

    let imageName = (viewModel.isSelected) ? "circle.fill" : "circle"
    checkButton.setImage(UIImage(systemName: imageName), for: .normal)
  }
}
