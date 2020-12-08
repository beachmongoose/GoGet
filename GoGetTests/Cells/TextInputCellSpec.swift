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

extension TextInputCellSpec {
    override func spec() {
        var subject: TextInputCell!
        beforeEach {
            subject = self.newSubject
        }
        describe("viewModel") {
            it("is correct type") {
                expect(subject.viewModel).to(beAKindOf(TextInputCellViewModelType.self))
            }
            it("is configured correctly") {
                let blank = ""
                expect(subject.viewModel?.title).to(equal("Name"))
                expect(subject.viewModel?.initialValue).to(equal(blank))
            }
        }
    }
}

extension TextInputCellSpec {
    var newSubject: TextInputCell {
        let subject: TextInputCell = UIView.cellFromNib()
        viewModel = MockTextInputCellViewModel()
        subject.viewModel = viewModel
        return subject
    }
}

class MockTextInputCellViewModel: TextInputCellViewModelType {
    var title = "Name"
    var initialValue = ""
    var updatedValue = Property<String?>(nil)
    var isValid = Property<Bool>(false)
    var validationSignal = SafePassthroughSubject<Void>()
}
