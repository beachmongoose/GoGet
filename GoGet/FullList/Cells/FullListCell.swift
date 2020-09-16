//
//  FullListCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class FullListCell: UITableViewCell {
  @IBOutlet var item: UILabel!
  @IBOutlet var dateBought: UILabel!
  var viewModel: FullListViewModel.CellViewModel? {
    didSet { setupCell() }
  }
}

extension FullListCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    item.text = "\(viewModel.name) (\(viewModel.quantity))"
    dateBought.text = viewModel.buyData

    if viewModel.isSelected {
      changeCellFormat(bg: UIColor.blue, item: UIColor.white, date: UIColor.white)
    } else {
      changeCellFormat(bg: UIColor.systemBackground, item: UIColor.black, date: UIColor.darkGray)
    }
  }

    func changeCellFormat(bg bgColor: UIColor, item itemColor: UIColor, date dateColor: UIColor) {
      backgroundColor = bgColor
      item.textColor = itemColor
      dateBought.textColor = dateColor
    }
}
