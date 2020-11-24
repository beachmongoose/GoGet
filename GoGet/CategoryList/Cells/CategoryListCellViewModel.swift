//
//  CategoryListCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/23/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

struct CategoryListCellViewModel: Equatable {
    var name: String

    init(category: Category) {
        self.name = category.name
    }
}
