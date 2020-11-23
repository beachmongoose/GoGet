//
//  DetailViewControllerSpec.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 11/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
@testable import GoGet
import Nimble
import Quick
import ReactiveKit

class DetailViewControllerSpec: QuickSpec {
    var viewModel: MockDetailViewModel!
}

extension DetailViewControllerSpec {
    override func spec() {
        var subject: DetailViewController!
        beforeEach {
            subject = self.newSubject
        }
        describe("save button") {
            context("when tapped") {
                beforeEach {
                    UIApplication.shared.sendAction(
                        subject.saveButton.action!,
                        to: subject.saveButton.target!,
                        from: nil,
                        for: nil
                    )
                }
                it("saves object") {
                    expect(self.viewModel.saveItemCallCount).to(equal(1))
                }
            }
        }
        describe("confirm button") {
            context("when tapped") {
                beforeEach {
                    UIApplication.shared.sendAction(
                        subject.clearButton.action!,
                        to: subject.clearButton.target!,
                        from: nil,
                        for: nil
                    )
                }
                it("clears data fields") {
                    expect(self.viewModel.clearDetailsCallCount).to(equal(1))
                }
            }
        }
        describe("tableView") {
            var cell: UITableViewCell?
            context("when cell viewModel is TextInputCellViewModel") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.viewModel.buildCells())
                    cell = self.dequeueCell(for: [0, 0], in: subject)
                }
                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(TextInputCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let textInputCell = cell as? TextInputCell
//                    let expectedViewModel = TextInputCellViewModel(title: "Item", initialValue: "")
                    expect(textInputCell?.viewModel).to(beAKindOf(TextInputCellViewModel.self))
//                    let cellViewModel = textInputCell?.viewModel
//                    expect(cellViewModel).to(equal(expectedViewModel))
                }
            }
            context("when cell viewModel is SegmentedControlCellViewModel") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.viewModel.buildCells())
                    cell = self.dequeueCell(for: [1, 1], in: subject)
                }
                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(SegmentedControlCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let segmentedControlCell = cell as? SegmentedControlCell
                    expect(segmentedControlCell?.viewModel).to(beAKindOf(SegmentedControlCellViewModel.self))
                }
            }
            context("when cell viewModel is DateInputCellViewModel") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.viewModel.buildCells())
                    cell = self.dequeueCell(for: [2, 2], in: subject)
                }
                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(DateCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let dateInputCell = cell as? DateCell
                    expect(dateInputCell?.viewModel).to(beAKindOf(DateCellViewModel.self))
                    let expectedViewModel = DateCellViewModel(title: "Category", initialValue: Date().convertedToString(), isEnabled: self.viewModel.bought)
                    let cellViewModel = dateInputCell?.viewModel
                    expect(cellViewModel).to(equal(expectedViewModel))
                }
            }
            context("when cell viewModel is NumberInputCellViewModel") {
                var quantity: UITableViewCell?
                var duration: UITableViewCell?
                beforeEach {
                    self.viewModel.tableData.replace(with: self.viewModel.buildCells())
                    quantity = self.dequeueCell(for: [3, 3], in: subject)
                    duration = self.dequeueCell(for: [4, 4], in: subject)
                }
                it("dequeues the proper cell") {
                    expect(quantity).to(beAKindOf(NumberInputCell.self))
                    expect(duration).to(beAKindOf(NumberInputCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let quantityInputCell = quantity as? NumberInputCell
                    let durationInputCell = duration as? NumberInputCell
                    expect(quantityInputCell?.viewModel).to(beAKindOf(NumberInputCellViewModel.self))
                    expect(durationInputCell?.viewModel).to(beAKindOf(NumberInputCellViewModel.self))
                }
            }
            context("when cell viewModel is CategoryCellViewModel") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.viewModel.buildCells())
                    cell = self.dequeueCell(for: [5, 5], in: subject)
                }
                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(CategoryInputCell.self))
                }
                it("configures the cell with the proper viewModel") {
                    let categoryInputCell = cell as? CategoryInputCell
                    expect(categoryInputCell?.viewModel).to(beAKindOf(CategoryInputCellViewModel.self))
                }
            }
        }
    }

    func dequeueCell(for index: IndexPath, in subject: DetailViewController!) -> UITableViewCell? {
        return subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: index)
    }
}

extension DetailViewControllerSpec {
    var newSubject: DetailViewController {
        viewModel = MockDetailViewModel()
        let viewController = DetailViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
        return viewController
    }
}

extension MockDetailViewModel {
    func buildCells() -> [CellType] {
        let titleCellViewModel = TextInputCellViewModel(title: "Item", initialValue: "")
        let titleCell: CellType = .nameInput(titleCellViewModel)

        let boughtCellViewModel = SegmentedControlCellViewModel(title: "Bought",
                                                                initialValue: bought.value,
                                                                updatedValue: bought)
        let boughtCell: CellType = .boughtStatusInput(boughtCellViewModel)

        let dateCellViewModel = DateCellViewModel(title: "Date",
                                                  initialValue: Date().convertedToString(),
                                                  isEnabled: bought)
        let dateCell: CellType = .dateInput(dateCellViewModel)

        let quantityCellViewModel = NumberInputCellViewModel(title: "Quantity",
                                                             title2: "",
                                                             initialValue: "1")
        let quantityCell: CellType = .numberInput(quantityCellViewModel)

        let durationCellViewModel = NumberInputCellViewModel(title: "Buy every",
                                                             title2: "days",
                                                             initialValue: "7")
        let durationCell: CellType = .numberInput(durationCellViewModel)

        let categoryInputCellViewModel = CategoryInputCellViewModel(title: "Category",
                                                                    initialValue: "None",
                                                                    updatedValue: categoryID)
        let categoryInputCell: CellType = .categoryInput(categoryInputCellViewModel)

        let array = [titleCell, boughtCell, dateCell,
                     quantityCell, durationCell, categoryInputCell]
        return array
    }
}

final class MockDetailViewModel: DetailViewModelType {
    var bought = Property<Bool>(false)
    var categoryID = Property<String?>(nil)
    var isValid = Property<Bool>(false)
    var newItem = Bool(true)
    var tableData = MutableObservableArray<CellType>([])

    var presentPopoverCallCount = 0
    var presentPopoverProperty = Property<String?>(nil)
    func presentPopover(selectedID: Property<String?>) {
        presentPopoverCallCount += 1
        presentPopoverProperty = selectedID
    }

    var saveItemCallCount = 0
    func saveItem() {
        saveItemCallCount += 1
    }

    var clearDetailsCallCount = 0
    func clearDetails() {
        clearDetailsCallCount += 1
    }

    var observeValidationUpdatesCount = 0
    func observeValidationUpdates() {
        observeValidationUpdatesCount += 1
    }
}
