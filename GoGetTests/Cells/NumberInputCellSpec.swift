//
//  NumberInputCellSpec.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 12/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
@testable import GoGet
import Nimble
import Quick
import ReactiveKit

class NumberInputCellSpec: QuickSpec {
    var viewModel: MockNumberInputCellViewModel!
}

final class MockNumberInputCellViewModel: NumberInputCellViewModelType {
    var title = "Quantity"
    var title2 = ""
    var initialValue = "1"
    var updatedValue = Property<String?>(nil)
    var isValid = Property<Bool>(true)
    var validationSignal = SafePassthroughSubject<Void>()
}
