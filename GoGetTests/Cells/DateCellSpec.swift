//
//  DateCellSpec.swift
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

class DateCellSpec: QuickSpec {
    var viewModel: MockDateCellViewModel!
}

final class MockDateCellViewModel: DateCellViewModelType {
    var title = "Date"
    var initialValue = Date().convertedToString()
    var updatedValue = Property<String?>(nil)
    var isEnabled = Property<Bool>(false)
    var isValid = Property<Bool>(true)
    var validationSignal = SafePassthroughSubject<Void>()
}
