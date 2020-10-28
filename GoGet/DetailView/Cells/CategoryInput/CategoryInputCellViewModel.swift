//
//  CategoryInputCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol CategoryInputCellViewModelType {
    var input: Property<String?> { get }
}

final class CategoryInputCellViewModel: CategoryInputCellViewModelType {
    var input = Property<String?>(nil)

    init() {
  }
}
