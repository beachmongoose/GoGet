//
//  FullListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

protocol FullListViewModelType {
    var alert: SafePassthroughSubject<Alert> { get }
    var inDeleteMode: Property<Bool> { get }
    var tableData: MutableObservableArray2D<String, FullListCellViewModel> { get }
    var tableCategories: [[FullListCellViewModel]] { get }
    func changeEditing()
    func presentDetail(_ index: IndexPath)
    func selectDeselectIndex(at indexPath: IndexPath)
    func clearSelectedItems()
    func presentSortOptions()
    func presentDeleteAlert()
}

final class FullListViewModel: FullListViewModelType {

    var alert = SafePassthroughSubject<Alert>()
    var inDeleteMode = Property<Bool>(false)
    var dictionary: [String: [Item]] = [: ]
    var tableCategories = [[FullListCellViewModel]]()
    let tableData = MutableObservableArray2D<String, FullListCellViewModel>(Array2D(sections: []))
    private var selectedItems = MutableObservableArray<String>([])
    private let bag = DisposeBag()
    private let coordinator: FullListCoordinatorType
    private let getItems: GetItemsType
    private let getCategories: GetCategoriesType
    private let sortTypeInstance: SortingInstanceType
    private var sortType: SortType {
        sortTypeInstance.sortType
    }

    init(coordinator: FullListCoordinatorType,
         getItems: GetItemsType = GetItems(),
         getCategories: GetCategoriesType = GetCategories(),
         sortTypeInstance: SortingInstanceType = SortingInstance.shared
    ) {
        self.coordinator = coordinator
        self.getItems = getItems
        self.getCategories = getCategories
        self.sortTypeInstance = sortTypeInstance
        fetchTableData()
        observeItemUpdates()
        observeSelectedItems()
    }
}

// MARK: - Datasource Helper
extension FullListViewModel {

    func fetchTableData() {
        let data = createDictionary().map { ($0.key, $0.value) }.sorted(by: {$0.0 < $1.0 })
        let sortedData = reOrder(data)
        let sections = sortedData.map { entry in
            return Array2D.Section(metadata: entry.0, items: entry.1)
        }
        tableData.replace(with: Array2D(sections: sections))
    }

    func createDictionary() -> [String: [FullListCellViewModel]] {
        dictionary = getItems.fetchByCategory(.fullList)
        let formattedDict: [String: [FullListCellViewModel]] = dictionary.mapValues {
            $0.map { item in
                let isSelected = selectedItems.array.contains(item.id)
                return FullListCellViewModel(item: item, isSelected: isSelected)
            }
        }
        return formattedDict
    }

  // MARK: - Organzing
    func reOrder(_ array: [(String, [FullListCellViewModel])]) -> [(String, [FullListCellViewModel])] {
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
}

// MARK: - Item Handling
extension FullListViewModel {

  func presentDetail(_ index: IndexPath) {
    let category = tableData.collection.sections[index.section].metadata
    let itemCategory = dictionary[category]
    guard let item = itemCategory?[index.row] else { fatalError("Unable to edit Item, out of range")}
    coordinator.presentDetail(item: item)
  }

  func changeEditing() {
    inDeleteMode.value.toggle()
  }

  func selectDeselectIndex(at indexPath: IndexPath) {
    let itemID = tableData.collection.sections[indexPath.section].items[indexPath.row].id
    var array = selectedItems.array
    if array.contains(itemID) {
      array.remove(at: array.firstIndex(of: itemID)!)
      selectedItems.replace(with: array)
    } else {
      selectedItems.append(itemID)
    }
  }

  func removeItems() {
    var allItems = getItems.load()
    for id in selectedItems.array {
      let index = getItems.indexNumber(for: id, in: allItems)
      allItems.remove(at: index)
    }
    selectedItems.removeAll()
    getItems.save(allItems)
  }

  func clearSelectedItems() {
    selectedItems.removeAll()
  }
}

// MARK: - Data Observation
extension FullListViewModel {
  func observeItemUpdates() {
    let defaults = UserDefaults.standard
    defaults.reactive.keyPath("Items", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
      self.fetchTableData()
    }
    .dispose(in: bag)

//    sortTypeInstance.sortType.observeNext { [weak self] _ in
//        self?.fetchTableData()
//    }
  }

  func observeSelectedItems() {
    selectedItems.observeNext { [weak self] _ in
      self?.fetchTableData()
    }
    .dispose(in: bag)
  }
}

extension FullListViewModel {
    func presentSortOptions() {
        let added = Alert.Action(title: addArrowTo("added")) { [weak self] in
            self?.sortTypeInstance.changeSortType(to: .added)
            self?.fetchTableData()
        }
        let name = Alert.Action(title: addArrowTo("name")) { [weak self] in
            self?.sortTypeInstance.changeSortType(to: .name)
            self?.fetchTableData()
        }
        let date = Alert.Action(title: addArrowTo("date")) { [weak self] in
            self?.sortTypeInstance.changeSortType(to: .date)
            self?.fetchTableData()
        }
        let sortOptionsAlert = Alert(title: "Sort by...", message: nil, otherActions: [name, date, added], style: .actionSheet)
        alert.send(sortOptionsAlert)
    }

    func addArrowTo(_ title: String) -> String {
        let sortTypeInstance: SortingInstanceType = SortingInstance.shared
        guard sortTypeInstance.sortType == SortType(rawValue: title.lowercased()) else {
            return "\(title) ↑" }
        return (sortTypeInstance.sortAscending == true) ? "\(title) ↓" : "\(title) ↑"
    }

    func presentDeleteAlert() {
        let yesOption = Alert.Action(title: "Yes") { [ weak self] in
            self?.removeItems()
            self?.changeEditing()
        }
        let noOption = Alert.Action(title: "No")
        let deleteAlertOptions = Alert(title: "Delete Selected?", message: nil, cancelAction: noOption, otherActions: [yesOption])
        alert.send(deleteAlertOptions)
    }
}
