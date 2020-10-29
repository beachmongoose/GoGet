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

protocol NumberInputCellViewModelType: InputCellViewModelType {
    var title: String { get }
    var title2: String? { get }
    var initialValue: String { get }
    var updatedValue: Property<String?> { get }
    var isValid: Property<Bool> { get }
}

final class NumberInputCellViewModel: NumberInputCellViewModelType {
    var title: String
    var title2: String?
    var initialValue: String
    var updatedValue = Property<String?>(nil)
    var isValid: Property<Bool> {
        guard updatedValue.value != nil else { return Property<Bool>(true) }
        guard let updatedValue = updatedValue.value else { return Property<Bool>(true) }
        return Property<Bool>(updatedValue.isInt)
    }

    init(title: String, title2: String, initialValue: String) {
        self.title = title
        self.title2 = title2
        self.initialValue = initialValue
  }
}
