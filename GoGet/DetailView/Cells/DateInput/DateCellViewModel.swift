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
    var isEnabled: Property<Bool> { get }
    var isValid: Property<Bool> { get }
    var validationSignal: SafePassthroughSubject<Void> { get }
}

final class DateCellViewModel: DateCellViewModelType {
    var title: String
    var initialValue: String
    let updatedValue = Property<String?>(nil)
    var isEnabled: Property<Bool>
    var isValid = Property<Bool>(false)
    var validationSignal = SafePassthroughSubject<Void>()
    let bag = DisposeBag()

    init(title: String, initialValue: String, isEnabled: Property<Bool>) {
        self.title = title
        self.initialValue = initialValue
        self.isEnabled = isEnabled
        observeValueUpdates()
        observeValidUpdates()
  }

    func observeValueUpdates() {
        updatedValue.observeNext { [weak self] value in
            guard value != nil else { self?.isValid.value = true
            return
            }
            guard let value = value else { return }
            self?.isValid.value = (value.dateFromString() <= Date())
        }
        .dispose(in: bag)
    }

    func observeValidUpdates() {
        isValid.removeDuplicates().observeNext { [weak self] _ in
            self?.validationSignal.send()
        }
        .dispose(in: bag)
    }
}

extension DateCellViewModel: Equatable {
    static func == (lhs: DateCellViewModel, rhs: DateCellViewModel) -> Bool {
        return  lhs.title == rhs.title &&
                lhs.initialValue == rhs.initialValue &&
                lhs.updatedValue.value == rhs.updatedValue.value &&
                lhs.isEnabled.value == rhs.isEnabled.value &&
                lhs.isValid.value == rhs.isValid.value
    }
}
