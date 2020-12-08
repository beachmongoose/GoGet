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

class CategoryInputCellSpec: QuickSpec {
    var viewModel: MockCategoryInputCellViewModel!
}

extension CategoryInputCellSpec {
    override func spec() {
        var cell: CategoryInputCell!
        describe("viewModel") {
            context("when set") {
                beforeEach {
                    cell = CategoryInputCell()
                    cell.viewModel = MockCategoryInputCellViewModel()
                }
                it("is configured correctly") {
                    expect(cell.viewModel?.title).to(equal("Category"))
                }
            }
        }
    }
}

extension CategoryInputCellSpec {
    var newSubject: CategoryInputCellViewModelType {
        let cell = CategoryInputCellViewModel(title: "Category", initialValue: "", updatedValue: Property<String?>(nil))
        return cell
    }
}

final class MockCategoryInputCellViewModel: CategoryInputCellViewModelType {
    var isValid = Property<Bool>(true)
    var title = "Category"
    var initialValue = "None"
    var updatedValue = Property<String?>(nil)
    var selectedCategoryName = Property<String>("None")
    var selectedCategoryIndex = Int?(nil)
}
