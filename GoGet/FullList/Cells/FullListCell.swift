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
    var viewModel: FullListCellViewModel? {
        didSet { setupCell() }
    }
}

extension FullListCell {
    func setupCell() {
        guard let viewModel = viewModel else { return }
        selectionStyle = .none
        item.text = "\(viewModel.name) (\(viewModel.quantity))"
        dateBought.text = viewModel.buyData

        backgroundColor = (viewModel.isSelected) ? UIColor.lightGray : UIColor.white
    }
}
