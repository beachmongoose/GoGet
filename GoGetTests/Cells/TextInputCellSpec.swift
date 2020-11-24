//
//  InputCellViewModelSpec.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 11/24/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
@testable import GoGet
import Nimble
import Quick
import ReactiveKit

class TextInputCellSpec: QuickSpec {
    var viewModel: MockTextInputCellViewModel!
}

class MockTextInputCellViewModel: TextInputCellViewModelType {
    var title = "Name"
    var initialValue = ""
    var updatedValue = Property<String?>(nil)
    var isValid = Property<Bool>(false)
    var validationSignal = SafePassthroughSubject<Void>()
}
