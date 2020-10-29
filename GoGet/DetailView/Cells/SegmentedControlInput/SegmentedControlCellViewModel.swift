//
//  SegmentedControlCellViewModelType.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/29/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol SegmentedControlCellViewModelType {
    var title: String { get }
    var initialValue: Bool { get }
    var updatedValue: Property<Bool> { get }
}

final class SegmentedControlCellViewModel: SegmentedControlCellViewModelType {
    var title: String
    var initialValue: Bool
    var updatedValue: Property<Bool>

    init(title: String, initialValue: Bool, updatedValue: Property<Bool>) {
        self.title = title
        self.initialValue = initialValue
        self.updatedValue = updatedValue
    }
}
