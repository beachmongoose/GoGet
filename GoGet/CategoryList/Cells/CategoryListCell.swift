//
//  CategoryListCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/30/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class CategoryListCell: UITableViewCell {
    @IBOutlet var nameLabel: UILabel!
    var viewModel: CategoryViewModel.CellViewModel? {
        didSet { setupCell() }
    }
}

extension CategoryListCell {
    func setupCell() {
        guard let viewModel = viewModel else { return }
        selectionStyle = .none
        nameLabel.text = viewModel.name
    }
}
