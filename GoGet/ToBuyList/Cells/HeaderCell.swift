//
//  HeaderCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/10/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!

    var viewModel: HeaderCellViewModel? {
        didSet {
            setUpCell()
        }
    }
}

extension HeaderCell {
    func setUpCell() {
        guard let viewModel = viewModel else { return }
        selectionStyle = .none
        titleLabel.text = viewModel.title
    }
}
