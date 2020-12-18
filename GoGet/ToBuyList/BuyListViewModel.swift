//
//  BuyListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

enum InputType: Equatable {
    case new
    case rename
}

protocol BuyListViewModelType {
    var alert: SafePassthroughSubject<Alert> { get }
    var tableData: MutableObservableArray2D<String, BuyListCellViewModel> { get }
    var itemsAreChecked: Property<Bool> { get }
    func presentDetail(for index: IndexPath)
    func presentSortOptions()
    func presentBoughtAlert()
    func sortBy(_ element: String?)
    func selectDeselectIndex(_ index: IndexPath)
//    func selectAll()
}

final class BuyListViewModel: BuyListViewModelType {
    var alert = SafePassthroughSubject<Alert>()
    let bag = DisposeBag()
    var dictionary: [String: [Item]] = [: ]
    let tableData = MutableObservableArray2D<String, BuyListCellViewModel>(Array2D(sections: []))
    var itemsAreChecked: Property<Bool> {
        return Property<Bool>(!selectedItems.value.isEmpty)
    }
    private var selectedItems = Property<Set<String>>(Set())
    private var sortSubject: SortSubject = .item

    private let coordinator: BuyListCoordinatorType
    private let getItems: GetItemsType
    private let getCategories: GetCategoriesType
    private let sortTypeInstance: SortingInstanceType

    init(
        coordinator: BuyListCoordinatorType,
        getItems: GetItemsType = GetItems(),
        getCategories: GetCategoriesType = GetCategories(),
        sortTypeInstance: SortingInstanceType = SortingInstance.shared) {
        self.coordinator = coordinator
        self.getItems = getItems
        self.getCategories = getCategories
        self.sortTypeInstance = sortTypeInstance
        observeDataUpdates()
    }
}

// MARK: - Datasource Helper
extension BuyListViewModel {
    func fetchTableData() {
        let sortedAscending = sortTypeInstance.categorySortAscending.value
        let data = createDictionary().map { ($0.key, $0.value) }.sorted(by: (sortedAscending == true) ? { $0.0 < $1.0 } : { $0.0 > $1.0 })
        let sections = reOrder(data).map { entry in
            return Array2D.Section(metadata: entry.0, items: entry.1)
        }
        tableData.replace(with: Array2D(sections: sections))
    }

    func createDictionary() -> [String: [BuyListCellViewModel]] {
        dictionary = getItems.fetchByCategory(.buyList)
        let formattedDict: [String: [BuyListCellViewModel]] = dictionary.mapValues {
            $0.map { item in
                let isSelected = selectedItems.value.contains(item.id)
                return BuyListCellViewModel(item: item, isSelected: isSelected)
            }
        }
        return formattedDict
    }

// MARK: - Organizing TableData
    func reOrder(_ array: [(String, [BuyListCellViewModel])]) -> [(String, [BuyListCellViewModel])] {
        var data = array
        guard data.contains(where: {$0.0 == "Uncategorized"}) else { return data }
        let index = data.firstIndex(where: { $0.0 == "Uncategorized" })
        let uncategorized = data[index!]
        data.remove(at: index!)
        data.append(uncategorized)
        return data
    }

    func sortBy(_ element: String?) {
        let method = String((element?.components(separatedBy: " ")[0])!)
        sortTypeInstance.changeSortType(to: SortType(rawValue: method)!)
        fetchTableData()
    }

// MARK: - Item Handling
    func presentDetail(for index: IndexPath) {
        let category = tableData.collection.sections[index.section].metadata
        let itemCategory = dictionary[category]
        guard let item = itemCategory?[index.row] else { fatalError("Unable to edit item, out of range.")}
        coordinator.presentDetail(item)
    }

    func selectDeselectIndex(_ index: IndexPath) {
        let itemID = tableData.collection.sections[index.section].items[index.row].id
        if selectedItems.value.contains(itemID) {
            selectedItems.value.remove(itemID)
        } else {
            selectedItems.value.insert(itemID)
        }
    }

//    func selectAll() {
//        _ = dictionary.mapValues {
//            $0.map { item in
//                selectedItems.value.insert(item.id)
//            }
//        }
//    }
    func markAsBought() {
        var allItems = getItems.items.array
        for id in selectedItems.value {
            let index = getItems.indexNumber(for: id, in: allItems)
            var item = allItems[index]
            item.boughtStatus = .bought(Date())
            allItems[index] = item
        }
        selectedItems.value = (Set())
        getItems.save(allItems)

    }
}
// MARK: - Data Observation
extension BuyListViewModel {
    func observeDataUpdates() {
        let itemsAndSelections = combineLatest(getItems.items, selectedItems, sortTypeInstance.categorySortAscending)
        itemsAndSelections.observeNext { [weak self] _, _, _ in
            self?.fetchTableData()
        }
        .dispose(in: bag)
    }
}

extension BuyListViewModel {
    func presentSortOptions() {
        sortSubject = .item
        let added = Alert.Action(title: addArrowTo("Added")) { [weak self] in
            self?.sortTypeInstance.changeSortType(to: .added)
        }
        let name = Alert.Action(title: addArrowTo("Name")) { [weak self] in
            self?.sortTypeInstance.changeSortType(to: .name)
        }
        let date = Alert.Action(title: addArrowTo("Date")) { [weak self] in
            self?.sortTypeInstance.changeSortType(to: .date)
        }
        let category = Alert.Action(title: addArrowTo("Category")) { [weak self] in
            self?.sortTypeInstance.changeCategoryOrder()
        }
        let sortOptionsAlert = Alert(title: "Sort by...", message: nil, otherActions: [name, date, added, category], style: .actionSheet)
        alert.send(sortOptionsAlert)
    }

    func addArrowTo(_ title: String) -> String {
        if sortSubject == .category {
            return (sortTypeInstance.categorySortAscending.value == true) ? "\(title) ↓" : "\(title) ↑"
        }
        let sort = sortTypeInstance
        guard sort.itemSortType.value == SortType(rawValue: title.lowercased()) else {
        return "\(title) ↑"
        }
        return (sort.itemSortAscending.value == true) ? "\(title) ↓" : "\(title) ↑"
    }

    func presentBoughtAlert() {
        let confirmOption = Alert.Action(title: "Yes") { [weak self] in
            self?.markAsBought()
        }
        let cancelOption = Alert.Action(title: "Cancel")
        let boughtAlert = Alert(title: "Mark as Bought?", message: nil, cancelAction: cancelOption, otherActions: [confirmOption])
        alert.send(boughtAlert)
    }
}
