//
//  CategoryViewControllerSpec.swift
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

class CategoryListViewControllerSpec: QuickSpec {
    var viewModel: MockCategoryListViewModel!
}

extension CategoryListViewControllerSpec {
    override func spec() {
        var subject: CategoryListViewController!
        beforeEach {
            subject = self.newSubject
        }
        describe("tableView") {
            var cell: UITableViewCell?
            context("when the datasource contains CategoryListCellViewModels") {
                beforeEach {
                    self.viewModel.tableData.replace(with: self.mockTableData())
                    cell = subject.tableView.dataSource?.tableView(subject.tableView, cellForRowAt: [0, 0])
                }

                it("dequeues the proper cell") {
                    expect(cell).to(beAKindOf(CategoryListCell.self))
                }

                it("configures the cell with the proper viewModel") {
                    let viewModel = CategoryListCellViewModel(category: .testCategory)
                    let categoryListCell = cell as? CategoryListCell
                    expect(categoryListCell?.viewModel).to(beAKindOf(CategoryListCellViewModel.self))
                    let categoryViewModel = categoryListCell?.viewModel
                    expect(categoryViewModel).to(equal(viewModel))
                }

                context("cell tapped") {
                    beforeEach { cell?.gestureRecognizers?.first?.tap() }

                    it("changes selected category") {
                        expect(self.viewModel.changeSelectedCategoryCallCount).to(equal(1))
                    }
                }

                context("cell receives long press") {
                    beforeEach {
                        cell?.gestureRecognizers?.first?.longPress()
                    }

                    it("brings up options alert") {
                        //TODO: 🥐 Test
                        expect(self.viewModel.changeSelectedIndexCallCount).to(equal(1))
                        expect(self.viewModel.longPressAlertCallCount).toEventually(equal(1))
                    }
                }
            }
        }
        describe("None Button") {
            context("when presssed") {
                beforeEach {
                    UIApplication.shared.sendAction(
                        subject.noneButton.action!,
                        to: subject.noneButton.target!,
                        from: nil,
                        for: nil)
                }
                it("sets category to None") {
                    expect(self.viewModel.changeSelectionCallCount).to(equal(1))
                    expect(self.viewModel.changeSelectedCategoryCallCount).to(equal(1))
                    expect(self.viewModel.changeSelectedIndexCallCount).to(equal(1))
                }
            }
        }
    }

    func mockTableData() -> [CategoryListCellViewModel] {
        let cell = CategoryListCellViewModel(category: .testCategory)
        let data = [cell]
        return data
    }
}

extension CategoryListViewControllerSpec {
    var newSubject: CategoryListViewController {
        viewModel = MockCategoryListViewModel()
        let viewController = CategoryListViewController(viewModel: viewModel)
        viewController.loadViewIfNeeded()
        return viewController
    }
}

final class MockCategoryListViewModel: CategoryListViewModelType {
    var alert = SafePassthroughSubject<Alert>()

    var changeSelectionCallCount = 0
    func changeSelection(to input: Int?) {
        changeSelectionCallCount += 1
        changeSelectedIndex(to: nil)
        changeSelectedCategory(for: nil)
    }

    var changeSelectedIndexCallCount = 0
    func changeSelectedIndex(to index: Int?) {
        changeSelectedIndexCallCount += 1
    }

    var changeSelectedCategoryCallCount = 0
    func changeSelectedCategory(for index: Int?) {
        changeSelectedCategoryCallCount += 1
    }

    var deleteCategoryCallCount = 0
    func deleteCategory() {
        deleteCategoryCallCount += 1
    }

    var longPressAlertCallCount = 0
    func longPressAlert() {
        longPressAlertCallCount += 1
    }

    var newCategoryAlertCallCount = 0
    func newCategoryAlert() {
        newCategoryAlertCallCount += 1
    }

    var nameData = Property<String>("")
    var tableData = MutableObservableArray<CategoryListCellViewModel>([])

    var createNewCategoryCallCount = 0
    func createNewCategory(action: UIAlertAction, for category: String) {
        createNewCategoryCallCount += 1
    }

    var renameCategoryCallCount = 0
    func renameCategory(action: UIAlertAction, with name: String) {
        renameCategoryCallCount += 1
    }

}
