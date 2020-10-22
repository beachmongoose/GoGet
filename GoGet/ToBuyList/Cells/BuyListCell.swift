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

  override func awakeFromNib() {
    super.awakeFromNib()
    observeCheckbox()
    observeSelectedState()
  }
}

extension BuyListCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    item.text = "\(viewModel.name) (\(viewModel.quantity))"
    dateBought.text = viewModel.buyData
  }

  func observeCheckbox() {
    checkButton.reactive.tap.observeNext { _ in
      self.viewModel?.isSelected.value.toggle()
      self.onTapped?()
    }
    .dispose(in: bag)
  }

  func observeSelectedState() {
    viewModel?.isSelected.observeNext { isChecked in
      let imageName = (isChecked) ? "circle.fill" : "circle"
      self.checkButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    .dispose(in: bag)
  }
}
