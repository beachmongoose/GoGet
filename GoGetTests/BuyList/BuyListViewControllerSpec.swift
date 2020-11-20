//
//  BuyListViewControllerSpecs.swift
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

class BuyListViewControllerSpec: QuickSpec {
    var viewModel: MockBuyListViewModel!
}

extension BuyListViewControllerSpec {
    override func spec() {
        var subject: BuyListViewController!
        beforeEach {
            subject = self.newSubject
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
//                        for: nil
//                    )
//                }
//            }
//        }
        describe("tableview") {
            //when the tableData has data
            // it dequeues the proper cell
            // it gives that cell the correct view model
            
            context("cell tapped") {
                beforeEach {
                    let data = self.createTableData()
                    self.viewModel.tableData.replace(with: Array2D(sections: data))
                    subject.tableView(subject.tableView, didSelectRowAt: IndexPath(row: 0, section: 0))
                }
                it("calls viewModel.presentDetail") {
                    expect(self.viewModel.presentDetailCallCount).to(equal(1))
                    expect(self.viewModel.presentDetailIndex).to(equal([0, 0]))
                }
            }
        }
    }

    func createTableData() -> [Array2D<String, BuyListCellViewModel>.Section] {
        let cell = BuyListCellViewModel(item: .test, isSelected: false)
        let array = [Array2D.Section(metadata: "metadata", items: [cell])]
        return array
    }
}

extension BuyListViewControllerSpec {
    var newSubject: BuyListViewController {
        viewModel = MockBuyListViewModel()
        let viewController = BuyListViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
        return viewController
    }
}

final class MockBuyListViewModel: BuyListViewModelType {
    var tableData = MutableObservableArray2D<String, BuyListCellViewModel>(Array2D(sections: []))

    var itemsAreChecked = Property<Bool>(false)

    var presentDetailCallCount = 0
    var presentDetailIndex: IndexPath!
    func presentDetail(for index: IndexPath) {
        presentDetailCallCount += 1
        presentDetailIndex = index
    }

    var markAsBoughtCallCount = 0
    func markAsBought() {
        markAsBoughtCallCount += 1
    }

    var sortByCallCount = 0
    func sortBy(_ element: String?) {
        sortByCallCount = 1
    }

    var selectDeselectIndexCallCount = 0
    var selectDeselectIndexEntry: IndexPath!
    func selectDeselectIndex(_ index: IndexPath) {
        selectDeselectIndexCallCount += 0
        selectDeselectIndexEntry = index
    }

    var selectAllCallCount = 0
    func selectAll() {
        selectAllCallCount += 1
    }
}
