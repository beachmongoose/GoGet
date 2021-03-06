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
        describe("tableview") {
            var cell: UITableViewCell?
            context("when cell viewModel is FullListCellViewModel") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    cell = subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: [0, 0])
                }
                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(FullListCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let viewModel = FullListCellViewModel(item: .test, isSelected: false)
                    let fullListCell = cell as? FullListCell
                    expect(fullListCell?.viewModel).to(beAKindOf(FullListCellViewModel.self))
                    let cellViewModel = fullListCell?.viewModel
                    expect(cellViewModel).to(equal(viewModel))
                }
            }
            context("when a cell receives long press") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    cell = subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: [0, 0])
                    cell?.gestureRecognizers?.first?.longPress()
                }
                it("activates delete mode") {
                    expect(self.viewModel.changeEditingCallCount).to(equal(1))
                }
            }
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
                it("clears selectedItems array") {
                    expect(self.viewModel.clearSelectedItemsCallCount).to(equal(2))
                }
                it("calls viewModel.changeEditing") {
                    expect(self.viewModel.changeEditingCallCount).to(equal(1))
                }
            }
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
                it("calls presentSortOptions") {
                    expect(self.viewModel.presentSortOptionsCallCount).to(equal(1))
                }
            }
        }
        describe("confirm button") {
            context("when tapped") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    self.viewModel.inDeleteMode.value = true
                    self.viewModel.selectedItems.append("itemID")
                    UIApplication.shared.sendAction(
                        subject.confirmButton.action!,
                        to: subject.confirmButton.target!,
                        from: nil,
                        for: nil)
                }
                it("calls presentDeleteAlert") {
                    expect(self.viewModel.presentDeleteAlertCallCount).to(equal(1))
                }
            }
        }
    }

    func mockTableData() -> Array2D<String, FullListCellViewModel> {
        let cell = FullListCellViewModel(item: .test, isSelected: false)
        let data = [Array2D.Section(metadata: "metadata", items: [cell])]
        let array = Array2D(sections: data)
        return array
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
    var alert = SafePassthroughSubject<Alert>()
    var selectedItems = MutableObservableArray<String>([])

    var presentSortOptionsCallCount = 0
    func presentSortOptions() {
        presentSortOptionsCallCount += 1
    }

    var presentDeleteAlertCallCount = 0
    func presentDeleteAlert() {
        presentDeleteAlertCallCount += 1
    }

    let bag = DisposeBag()
    var inDeleteMode = Property<Bool>(false)
    var tableData = MutableObservableArray2D<String, FullListCellViewModel>(Array2D(sections: []))
    var tableCategories: [[FullListCellViewModel]] = []

    var changeEditingCallCount = 0
    func changeEditing() {
        inDeleteMode.value.toggle()
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
