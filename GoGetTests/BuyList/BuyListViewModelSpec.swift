//
//  BuyListViewModelSpec.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 12/7/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
@testable import GoGet
import Nimble
import PromiseKit
import Quick
import ReactiveKit

class BuyListViewModelSpec: QuickSpec {
    var getItems: MockGetItems!
    var coordinator: BuyListCoordinatorType!
    var categoryStore: CategoryStoreType!
    var sortTypeInstance: SortingInstanceType!
}

extension BuyListViewModelSpec {
    override func spec() {
        var subject: BuyListViewModel!
        beforeEach {
            subject = self.newSubject
        }
        describe("viewModel") {
            context("when created") {
                it("calls fetchByCategory") {
                    expect(self.getItems.fetchByCategoryCallCount).to(equal(1))
                }
            }
        }
    }
}

extension BuyListViewModelSpec {
    var newSubject: BuyListViewModel {
        coordinator = BuyListCoordinator()
        getItems = MockGetItems()

        let viewModel = BuyListViewModel(coordinator: coordinator, getItems: getItems)

        return viewModel
    }
}

final class MockGetItems: GetItemsType {

    var saveCallCount = 0
    func save(_ items: [Item]) {
        saveCallCount += 1
    }

    var loadCallCount = 0
    func load() -> [Item] {
        loadCallCount += 1
        return [Item.test]
    }

    var indexNumberCallCount = 0
    func indexNumber(for item: String, in array: [Item]) -> Int {
        indexNumberCallCount += 1
        return 0
    }

    var fetchByCategoryCallCount = 0
    func fetchByCategory(_ view: ListView) -> [String: [Item]] {
        fetchByCategoryCallCount += 1
        return ["Test": [Item.test]]
    }

    var isDuplicateCallCount = 0
    func isDuplicate(_ name: String) -> Bool {
        isDuplicateCallCount += 1
        return false
    }

    var updateCallCount = 0
    func update(_ item: Item) -> Promise<Void> {
        updateCallCount += 1
        return Promise<Void> { seal in
            firstly {
                loadPromise()
            }.then { array in
                self.replaceItem(in: array, with: item)
            }.then { allItems in
                self.savePromise(allItems)
            }.done {
                seal.fulfill(())
            }.catch { _ in
                fatalError("Unable to save Item")
            }
        }
    }

    func upSert(_ item: Item) -> Promise<Void> {
        Promise<Void> { seal in
            firstly {
                loadPromise()
            }.then { array in
                self.appendItem(item, to: array)
            }.then { allItems in
                self.savePromise(allItems)
            }.done {
                seal.fulfill(())
            }.catch { _ in
                fatalError("Unable to save Item")
            }
        }
    }

    var appendItemCallCount = 0
    func appendItem(_ item: Item, to array: [Item]) -> Promise<[Item]> {
        return Promise<[Item]> { seal in
            appendItemCallCount += 1
            var allItems = array
            allItems.append(item)
            seal.fulfill(allItems)
        }
    }

    func loadPromise() -> Promise<[Item]> {
        return Promise<[Item]> { seal in
            let array = load()
            seal.fulfill(array)
        }
    }

    var savePromiseCallCount = 0
    func savePromise(_ items: [Item]) -> Promise<Void> {
        Promise<Void> { seal in
            savePromiseCallCount += 1
            seal.fulfill(())
        }
    }

    func replaceItem(in array: [Item], with item: Item) -> Promise<[Item]> {
        return Promise<[Item]> {seal in
        let index = indexNumber(for: item.id, in: array)
        var allItems = array
        allItems[index] = item
        seal.fulfill(allItems)
        }
    }
}
