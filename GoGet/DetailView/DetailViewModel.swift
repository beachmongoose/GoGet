//
//  DetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import PromiseKit
import ReactiveKit

enum CellType {
    case nameInput(TextInputCellViewModelType)
    case boughtStatusInput(SegmentedControlCellViewModelType)
    case dateInput(DateCellViewModelType)
    case numberInput(NumberInputCellViewModelType)
    case categoryInput(CategoryInputCellViewModelType)
}

protocol DetailViewModelType {
    func presentPopover(selectedID: Property<String?>)
    func saveItem()
    func clearDetails()
    func observeValidationUpdates()

    var tableData: MutableObservableArray<CellType> { get }

    var isValid: Property<Bool> { get }
    var newItem: Bool { get }
}

final class DetailViewModel: DetailViewModelType {
    var item: Item
    var newItem = false

// Data field bindings
    let bought = Property<Bool>(false)
    let isValid = Property<Bool>(true)
    let categoryID = Property<String?>(nil)

    var tableData = MutableObservableArray<CellType>([])

    private var cellViewModels = Property<[InputCellViewModelType]>([])
    private let coordinator: DetailViewCoordinatorType
    private let getItems: GetItemsType
    private let bag = DisposeBag()

    init(coordinator: DetailViewCoordinatorType,
         getItems: GetItemsType = GetItems(),
         item: Item ) {
    self.coordinator = coordinator
    self.getItems = getItems
    self.item = item
    buildCellViewModels()
  }

    func buildCellViewModels() {
        let titleCellViewModel = TextInputCellViewModel(title: "Item", initialValue: item.name)
        let titleCell: CellType = .nameInput(titleCellViewModel)

        let boughtCellViewModel = SegmentedControlCellViewModel(title: "Bought",
                                                                initialValue: bought.value,
                                                                updatedValue: bought)
        let boughtCell: CellType = .boughtStatusInput(boughtCellViewModel)

        let date = item.dateBought.convertedToString()
        let dateCellViewModel = DateCellViewModel(title: "Date",
                                                  initialValue: date,
                                                  isEnabled: bought)
        let dateCell: CellType = .dateInput(dateCellViewModel)

        let quantity = String(item.quantity)
        let quantityCellViewModel = NumberInputCellViewModel(title: "Quantity",
                                                             title2: "",
                                                             initialValue: quantity)
        let quantityCell: CellType = .numberInput(quantityCellViewModel)

        let duration = String(item.duration)
        let durationCellViewModel = NumberInputCellViewModel(title: "Buy every",
                                                             title2: "days",
                                                             initialValue: duration)
        let durationCell: CellType = .numberInput(durationCellViewModel)

        let id = item.categoryID ?? "None"
        let categoryInputCellViewModel = CategoryInputCellViewModel(title: "Category",
                                                                    initialValue: id,
                                                                    updatedValue: categoryID)
        let categoryInputCell: CellType = .categoryInput(categoryInputCellViewModel)

        let array = [titleCell, boughtCell, dateCell,
                     quantityCell, durationCell, categoryInputCell]
        let cellViewModels: [InputCellViewModelType] = [titleCellViewModel, dateCellViewModel,
                                                    quantityCellViewModel, durationCellViewModel,
                                                    categoryInputCellViewModel]
        self.cellViewModels.value = cellViewModels
        tableData.replace(with: array)
    }

    func observeValidationUpdates() {
        isValid.value = (cellViewModels.value.filter { $0.isValid.value == false}).isEmpty
    }

    func saveItem() {

        let updatedValues = cellViewModels.value.map { return ($0.updatedValue.value == nil) ? $0.initialValue : $0.updatedValue.value }

        let adjustedItem = Item(
            name: updatedValues[0] ?? "",
            id: item.id,
            quantity: finalInt(updatedValues[2]),
            duration: finalInt(updatedValues[3]),
            boughtStatus: finalBoughtStatus(updatedValues[1]),
            dateAdded: item.dateAdded,
            categoryID: finalCategoryID(updatedValues[4])
        )
        getItems.update(adjustedItem)
            .done(coordinator.confirmSaveEdit)
            .catch { _ in
                print("Unable to save")
            }
    }

    func clearDetails() {
        buildCellViewModels()
    }
}

// MARK: - Categories
extension DetailViewModel {
    func presentPopover(selectedID: Property<String?>) {
    coordinator.presentPopover(selectedID: selectedID)
    }
}

// MARK: - Format Values
extension DetailViewModel {
    func finalInt(_ string: String?) -> Int {
        guard let int = string else {
            fatalError("Failed to create item, quantity was nil")
        }
        return Int(int) ?? 1
    }

    func finalBoughtStatus(_ input: String?) -> BoughtStatus {
        guard let string = input else {
            fatalError("Failed to create item, no date bought selected")
        }
        guard bought.value == true else { return .notBought }
        let date = string.dateFromString()
        return .bought(date)
    }

    func finalCategoryID(_ string: String?) -> String? {
        guard let idString = string else { return nil }
        return idString
    }
}
