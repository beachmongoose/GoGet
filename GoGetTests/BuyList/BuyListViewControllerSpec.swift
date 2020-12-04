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
        describe("sort button") {
            context("when tapped") {
                beforeEach {
                    UIApplication.shared.sendAction(
                        subject.sortButton.action!,
                        to: subject.sortButton.target!,
                        from: nil,
                        for: nil
                    )
                }
                it("presents sort options alert") {
                    expect(self.viewModel.presentSortOptionsCallCount).to(equal(1))
                }
            }
        }
        describe("confirm button") {
            context("when tapped") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    let cell = subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: [0, 0]) as? BuyListCell
                    cell?.checkButton.gestureRecognizers?.first?.tap()
                    UIApplication.shared.sendAction(
                        subject.confirmButton.action!,
                        to: subject.confirmButton.target!,
                        from: nil,
                        for: nil
                    )
                }
                it("presents bought alert") {
                     expect(self.viewModel.presentBoughtAlertCallCount).to(equal(1))
                }
            }
        }
        describe("tableview") {
            var cell: UITableViewCell?
            context("when cell viewModel is BuyListCellViewModel") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    cell = subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: [0, 0])
                }
                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(BuyListCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let buyListCell = cell as? BuyListCell
                    let expectedViewModel = BuyListCellViewModel(item: .test, isSelected: false)
                    expect(buyListCell?.viewModel).to(beAKindOf(BuyListCellViewModel.self))
                    let cellViewModel = buyListCell?.viewModel
                    expect(cellViewModel).to(equal(expectedViewModel))
                }
            }
            context("cell tapped") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    let cell = subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: [0, 0]) as? BuyListCell
                    cell?.gestureRecognizers?.first?.tap()
                }
                it("calls viewModel.presentDetail") {
                    expect(self.viewModel.presentDetailCallCount).to(equal(1))
                    expect(self.viewModel.presentDetailIndex).to(equal([0, 0]))
                }
            }
        }
    }

    func mockTableData() -> Array2D<String, BuyListCellViewModel> {
        let cell = BuyListCellViewModel(item: .test, isSelected: false)
        let data = [Array2D.Section(metadata: "metadata", items: [cell])]
        let array = Array2D(sections: data)
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
    var alert = SafePassthroughSubject<Alert>()

    var presentSortOptionsCallCount = 0
    func presentSortOptions() {
        presentSortOptionsCallCount += 1
    }

    var presentBoughtAlertCallCount = 0
    func presentBoughtAlert() {
        presentBoughtAlertCallCount += 1
    }

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
}
