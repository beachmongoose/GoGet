//
//  NoneCell.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/22/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class NoneCell: UITableViewCell {
  @IBOutlet var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
      label.text = "None"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
