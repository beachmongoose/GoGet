//
//  DetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import ReactiveKit

//TODO: CREATE DIFFERENT VIEW MODELS FOR NEW ITEM AND EDIT ITEM
protocol DetailViewModelType {
    func presentPopover(sender: UIButton, id: Property<String?>)
    func saveItem()
    func clearDetails()
    var item: Item? { get }
    func observeValidationUpdates()

    var tableData: MutableObservableArray<DetailViewModel.CellType> { get }

    var isValid: Property<Bool> { get }
}

//TODO: FORMAT AS TABLE
final class DetailViewModel: DetailViewModelType {
    enum CellType {
        case nameInput(TextInputCellViewModelType)
        case boughtStatusInput(SegmentedControlCellViewModelType)
        case dateInput(DateCellViewModelType)
        case numberInput(NumberInputCellViewModelType)
        case categoryInput(CategoryInputCellViewModelType)
    }

    var item: Item?
    var newItemStatus: Bool {
        return item == nil
  }

// Data field bindings
    let bought = Property<Bool>(false)
    let isValid = Property<Bool>(false)
    let categoryID = Property<String?>(nil)

    var tableData = MutableObservableArray<CellType>([])

    private var cellViewModels = Property<[InputCellViewModelType]>([])
    private let coordinator: DetailViewCoordinatorType
    private let getItems: GetItemsType
    private let bag = DisposeBag()

    init(coordinator: DetailViewCoordinatorType,
         getItems: GetItemsType = GetItems(),
         item: Item? ) {
    self.coordinator = coordinator
    self.getItems = getItems
    self.item = item
    buildCellViewModels()
  }

    func buildCellViewModels() {
        let titleCellViewModel = TextInputCellViewModel(title: "Item", initialValue: item?.name ?? "")
        let titleCell: CellType = .nameInput(titleCellViewModel)

        let boughtCellViewModel = SegmentedControlCellViewModel(title: "Bought",
                                                                initialValue: bought.value,
                                                                updatedValue: bought)
        let boughtCell: CellType = .boughtStatusInput(boughtCellViewModel)

        let date = (item?.dateBought ?? Date()).convertedToString()
        let dateCellViewModel = DateCellViewModel(title: "Date",
                                                  initialValue: date,
                                                  isEnabled: bought)
        let dateCell: CellType = .dateInput(dateCellViewModel)

        let quantity = String(item?.quantity ?? 1)
        let quantityCellViewModel = NumberInputCellViewModel(title: "Quantity",
                                                             title2: "",
                                                             initialValue: quantity)
        let quantityCell: CellType = .numberInput(quantityCellViewModel)

        let duration = String(item?.duration ?? 7)
        let durationCellViewModel = NumberInputCellViewModel(title: "Buy every",
                                                             title2: "days",
                                                             initialValue: duration)
        let durationCell: CellType = .numberInput(durationCellViewModel)

        let id = item?.categoryID ?? "None"
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
        var idString: String {
            return (self.item == nil) ? UUID().uuidString : item!.id
        }

        let updatedValues = cellViewModels.value.map { return ($0.updatedValue.value == nil) ? $0.initialValue : $0.updatedValue.value }

        let adjustedItem = Item(
            name: updatedValues[0] ?? "",
            id: idString,
            quantity: finalInt(updatedValues[2]),
            duration: finalInt(updatedValues[3]),
            boughtStatus: finalBoughtStatus(updatedValues[1]),
            dateAdded: item?.dateAdded ?? Date(),
            categoryID: finalCategoryID(updatedValues[4])
        )
        upSert(adjustedItem)
    }

    //TODO: PROMISE
    func upSert(_ item: Item) {
        var allItems = getItems.load()

        if self.item == nil {
            allItems.append(item)
            getItems.save(allItems)
        } else {
            replace(in: allItems, with: item)
        }
        coordinator.confirmSave(newItemStatus)
        self.item = nil
        clearDetails()
    }

    func clearDetails() {
        item = nil
        buildCellViewModels()
    }

    func replace(in array: [Item], with item: Item) {
        guard let originalItem = self.item else { return }
        let index = getItems.indexNumber(for: originalItem.id, in: array)
        var allItems = array
        allItems[index] = item
        getItems.save(allItems)
    }
}

// MARK: - Categories
extension DetailViewModel {
    func presentPopover(sender: UIButton, id: Property<String?>) {
    coordinator.presentPopover(sender: sender, selectedID: id)
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
