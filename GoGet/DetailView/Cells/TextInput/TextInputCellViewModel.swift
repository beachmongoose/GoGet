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
}

final class TextInputCellViewModel: TextInputCellViewModelType {
    
    let title: String
    let initialValue: String
    var updatedValue = Property<String?>(nil)
    let isValid = Property<Bool>(false)

    init(title: String, initialValue: String) {
        self.title = title
        self.initialValue = initialValue
        observeValueUpdates()
  }

    func observeValueUpdates() {
        updatedValue.observeNext { value in
            self.isValid.value = (value != "")
        }
        .dispose()
    }
}
