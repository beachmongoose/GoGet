//
//  DateCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol DateCellViewModelType {
    var title: String { get }
    var initialValue: String { get }
    var updatedValue: Property<String?> { get }
}

final class DateCellViewModel: DateCellViewModelType {
    var title: String
    var initialValue: String
    var updatedValue = Property<String?>(nil)

    init(title: String, initialValue: String) {
        self.title = title
        self.initialValue = initialValue
  }
}
