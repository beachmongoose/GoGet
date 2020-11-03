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
    var validationSignal: SafePassthroughSubject<Void> { get }
}

final class NumberInputCellViewModel: NumberInputCellViewModelType {
    var title: String
    var title2: String?
    var initialValue: String
    var updatedValue = Property<String?>(nil)
    var isValid = Property<Bool>(false)
    var validationSignal = SafePassthroughSubject<Void>()
    let bag = DisposeBag()

    init(title: String, title2: String, initialValue: String) {
        self.title = title
        self.title2 = title2
        self.initialValue = initialValue
        observeValueUpdates()
        observeValidationUpdates()
  }

    func observeValueUpdates() {
        updatedValue.observeNext { value in
            guard value != nil else { self.isValid.value = true
            return
            }
            guard let value = value else { return }
            self.isValid.value = value.isInt
        }
        .dispose(in: bag)
    }

    func observeValidationUpdates() {
        isValid.removeDuplicates().observeNext { _ in
            self.validationSignal.send()
        }
        .dispose(in: bag)
    }
}
