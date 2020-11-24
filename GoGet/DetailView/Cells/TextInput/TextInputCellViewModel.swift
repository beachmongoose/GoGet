//
//  TitleInputViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import ReactiveKit

protocol TextInputCellViewModelType: InputCellViewModelType {
    var title: String { get }
    var initialValue: String { get }
    var updatedValue: Property<String?> { get }
    var isValid: Property<Bool> { get }
    var validationSignal: SafePassthroughSubject<Void> { get }
}

final class TextInputCellViewModel: TextInputCellViewModelType {
    let title: String
    let initialValue: String
    var updatedValue = Property<String?>(nil)
    let isValid = Property<Bool>(false)
    let bag = DisposeBag()
    let validationSignal = SafePassthroughSubject<Void>()

    init(title: String, initialValue: String) {
        self.title = title
        self.initialValue = initialValue
        observeValueUpdates()
        observeValidUpdates()
  }

    func observeValueUpdates() {
        updatedValue.observeNext { value in
            self.isValid.value = (value != "")
        }
        .dispose(in: bag)
    }

    func observeValidUpdates() {
        isValid.removeDuplicates().observeNext { _ in
            self.validationSignal.send()
        }
        .dispose(in: bag)
    }
}

extension TextInputCellViewModel: Equatable {
    static func == (lhs: TextInputCellViewModel, rhs: TextInputCellViewModel) -> Bool {
        return  lhs.title == rhs.title &&
                lhs.initialValue == rhs.initialValue &&
                lhs.isValid.value == rhs.isValid.value &&
                lhs.updatedValue.value == rhs.updatedValue.value
    }
}
