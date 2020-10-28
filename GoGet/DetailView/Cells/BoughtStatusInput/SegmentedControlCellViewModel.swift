//
//  BoughtStatusCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol SegmentedControlCellViewModelType {
    var title: String { get }
    var initialValue: Int { get }
    var updatedValue: Property<Int> { get }
}

final class SegmentedControlCellViewModel: SegmentedControlCellViewModelType {
    var title: String
    var initialValue: Int
    var updatedValue = Property<Int>(1)

    init(title: String, initialValue: Int) {
        self.title = title
        self.initialValue = 1
        observeValueUpdates()
  }

    func observeValueUpdates() {
        updatedValue.observeNext { _ in
            print("none")
        }
        .dispose()
    }
}
