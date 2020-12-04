//
//  CategoryInputCell.swift
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

class categoryInputCellSpec: QuickSpec {
    var viewModel: MockCategoryInputCellViewModel!
}

final class MockCategoryInputCellViewModel: CategoryInputCellViewModelType {
    var isValid = Property<Bool>(true)
    var title = "Category"
    var initialValue = "None"
    var updatedValue = Property<String?>(nil)
    var selectedCategoryName = Property<String>("None")
    var selectedCategoryIndex = Int?(nil)
}
