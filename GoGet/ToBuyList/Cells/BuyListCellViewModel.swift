//
//  BuyListCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

struct BuyListCellViewModel {
    var name: String
    var id: String
    var quantity: String
    var buyData: String
    var isSelected: Bool

    init(item: Item, isSelected: Bool) {
        self.name = item.name
        self.id = item.id
        self.quantity = String(item.quantity)
        self.buyData = item.buyData
        self.isSelected = isSelected
    }
}
