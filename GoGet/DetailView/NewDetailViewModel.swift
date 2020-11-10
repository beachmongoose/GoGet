//
//  NewDetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

final class NewDetailViewModel: DetailViewModelType {
// Data field bindings
    let bought = Property<Bool>(false)
    let isValid = Property<Bool>(false)
    let categoryID = Property<String?>(nil)

    var tableData = MutableObservableArray<CellType>([])
    var newItem = true

    private var cellViewModels = Property<[InputCellViewModelType]>([])
    private let coordinator: DetailViewCoordinatorType
    private let getItems: GetItemsType
    private let bag = DisposeBag()

    init(coordinator: DetailViewCoordinatorType,
         getItems: GetItemsType = GetItems()) {
    self.coordinator = coordinator
    self.getItems = getItems
    buildCellViewModels()
  }

    func buildCellViewModels() {
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
      let updatedValues = cellViewModels.value.map { return $0.updatedValue.value }

        let adjustedItem = Item(
            name: updatedValues[0] ?? "",
            id: UUID().uuidString,
            quantity: finalInt(updatedValues[2]),
            duration: finalInt(updatedValues[3]),
            boughtStatus: finalBoughtStatus(updatedValues[1]),
            dateAdded: Date(),
            categoryID: finalCategoryID(updatedValues[4])
        )
        getItems.upSert(adjustedItem)
            .done(coordinator.confirmSaveNew)
            .catch { _ in
                print("Unable to save")
            }
    }

    func clearDetails() {
        categoryID.value = nil
        buildCellViewModels()
    }
}

// MARK: - Categories
extension NewDetailViewModel {
    func presentPopover(selectedID: Property<String?>) {
    coordinator.presentPopover(selectedID: selectedID)
    }
}

// MARK: - Format Values
extension NewDetailViewModel {
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
