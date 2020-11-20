//
//  FullListViewControllerSpec.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 11/20/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
@testable import GoGet
import Nimble
import Quick
import ReactiveKit

class FullListViewControllerSpec: QuickSpec {
    var viewModel: MockFullListViewModel!
}

extension FullListViewControllerSpec {
    override func spec() {
        var subject: FullListViewController!
        beforeEach {
            subject = self.newSubject
        }
        describe("cancel button") {
            context("when tapped") {
                beforeEach {
                    self.viewModel.inDeleteMode.value = true
                    UIApplication.shared.sendAction(
                        subject.cancelButton.action!,
                        to: subject.cancelButton.target!,
                        from: nil,
                        for: nil
                    )
                }
                it("calls viewModel.Clear") {
                    expect(self.viewModel.clearSelectedItemsCallCount).to(equal(1))
                    expect(self.viewModel.changeEditingCallCount).to(equal(1))
                }
            }
        }
//        describe("sort button") {
//            context("when tapped") {
//                beforeEach {
//                    UIApplication.shared.sendAction(
//                        subject.sortButton.action!,
//                        to: subject.sortButton.target!,
//                        from: nil,
//                        for: nil
//                    )
//                    //calls presentSortOptions. Select dateAdded
//                    //expect
//                }
//                it("calls presentSortOptions") {
//                    expect(self.viewModel.sortByCallCount).to(equal(1))
//                }
//            }
//        }
//        describe("confirm button") {
//            context("when tapped") {
//                beforeEach {
//                    UIApplication.shared.sendAction(
//                        subject.confirmButton.action!,
//                        to: subject.confirmButton.target!,
//                        from: nil,
//                        for: nil)
//                    //activates presentConfirmRequest. If yes
//                    //expect(self.viewModel.removeItemsCallCount).to(equal(1))
//                }
//            }
//        }
    }
}

extension FullListViewControllerSpec {
    var newSubject: FullListViewController {
        viewModel = MockFullListViewModel()
        let viewController = FullListViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
        return viewController
    }
}

final class MockFullListViewModel: FullListViewModelType {
    var inDeleteMode = Property<Bool>(false)
    var tableData = MutableObservableArray2D<String, FullListViewModel.CellViewModel>(Array2D(sections: []))
    var tableCategories: [[FullListViewModel.CellViewModel]] = []

    var changeEditingCallCount = 0
    func changeEditing() {
        changeEditingCallCount += 1
    }
    var presentDetailCallCount = 0
    var presentDetailIndex: IndexPath!
    func presentDetail(_ index: IndexPath) {
        presentDetailCallCount += 1
        presentDetailIndex = index
    }

    var selectDeselectIndexEntryCount = 0
    var selectDeselectIndexEntry: IndexPath!
    func selectDeselectIndex(at indexPath: IndexPath) {
        selectDeselectIndexEntryCount += 1
        selectDeselectIndexEntry = indexPath
    }
    var clearSelectedItemsCallCount = 0
    func clearSelectedItems() {
        clearSelectedItemsCallCount += 1
    }

    var removeItemsCallCount = 0
    func removeItems() {
        removeItemsCallCount += 1
    }

    var sortByCallCount = 0
    func sortBy(_ element: String?) {
        sortByCallCount += 1
    }
}
