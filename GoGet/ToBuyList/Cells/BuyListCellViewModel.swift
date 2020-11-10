//
//  BuyListCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol BuyListCellViewModelType {
    var name: String { get }
    var id: String { get }
    var quantity: String { get }
    var buyData: String { get }
    var isSelected: Bool { get }
}

struct BuyListCellViewModel: BuyListCellViewModelType {
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
