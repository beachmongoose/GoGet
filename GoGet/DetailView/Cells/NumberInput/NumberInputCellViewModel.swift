//
//  NumberInputCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/27/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import Foundation
import ReactiveKit

protocol NumberInputCellViewModelType {
    var title: String { get }
    var title2: String? { get }
    var input: Property<String?> { get }
}

final class NumberInputCellViewModel: NumberInputCellViewModelType {
    var title: String
    var title2: String?
    var input = Property<String?>(nil)

    init(title: String, title2: String) {
        self.title = title
        self.title2 = title2
  }
}
