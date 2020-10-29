//
//  DateCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol DateCellViewModelType: InputCellViewModelType {
    var title: String { get }
    var initialValue: String { get }
    var updatedValue: Property<String?> { get }
    var isEnabled: Bool { get }
    var isValid: Property<Bool> { get }
}

final class DateCellViewModel: DateCellViewModelType {
    var title: String
    var initialValue: String
    let updatedValue = Property<String?>(nil)
    var isEnabled: Bool
    var isValid: Property<Bool> {
        guard updatedValue.value != nil else { return Property<Bool>(true) }
        return Property<Bool>(dateFromString(updatedValue.value) <= Date())
    }

    init(title: String, initialValue: String, isEnabled: Bool) {
        self.title = title
        self.initialValue = initialValue
        self.isEnabled = isEnabled
  }

    func dateFromString(_ stringDate: String?) -> Date {
        guard let stringDate = stringDate else { return Date() }
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yy"
        return format.date(from: stringDate) ?? Date()
    }
}
