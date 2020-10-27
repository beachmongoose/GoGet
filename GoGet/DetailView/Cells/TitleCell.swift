//
//  TitleCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
  @IBOutlet var titleInput: UITextField!
  var viewModel: DetailViewModel? {
  didSet { setupCell() }
  }
}

extension TitleCell {
  func setupCell() {
    guard let viewModel = viewModel else { return }
    selectionStyle = .none
    titleInput.text = viewModel.itemName.value
    titleInput.reactive.text.bind(to: viewModel.itemName)
  }
}
