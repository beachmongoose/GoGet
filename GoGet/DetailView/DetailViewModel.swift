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
    func presentPopover(sender: UIButton)
    func saveItem()
    func clearDetails()
    var item: Item? { get }

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

    var categories: [Category] = []

// Data field bindings
    let itemName = Property<String?>(nil)
    let itemQuantity = Property<String?>(nil)
    let dateBought = Property<String?>(nil)
    let itemDuration = Property<String?>(nil)
    let bought = Property<Bool>(false)

    var tableData = MutableObservableArray<CellType>([])

    let isValid = Property<Bool>(false)

    private var cellViewModels = MutableObservableArray<InputCellViewModelType>([])
    private let coordinator: DetailViewCoordinatorType
    private let getCategories: GetCategoriesType
    private let getItems: GetItemsType
    private let bag = DisposeBag()

    init(coordinator: DetailViewCoordinatorType,
         getCategories: GetCategoriesType = GetCategories(),
         getItems: GetItemsType = GetItems(),
         item: Item? ) {
    self.coordinator = coordinator
    self.getCategories = getCategories
    self.getItems = getItems
    self.item = item
    self.categories = getCategories.load()
    buildCellViewModels()
    clearDetails()
    observeInput()
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
                                                  isEnabled: bought.value)
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

        let categoryID = item?.categoryID ?? "None"
        let categoryInputCellViewModel = CategoryInputCellViewModel(title: "Category",
                                                                    initialValue: categoryID)
        let categoryInputCell: CellType = .categoryInput(categoryInputCellViewModel)

        let array = [titleCell, boughtCell, dateCell,
                     quantityCell, durationCell, categoryInputCell]
        let modelArray: [InputCellViewModelType] = [titleCellViewModel, dateCellViewModel,
                                                    quantityCellViewModel, durationCellViewModel,
                                                    categoryInputCellViewModel]
        cellViewModels.replace(with: modelArray)
        tableData.replace(with: array)
    }

    func observeBoughtSignal() {
        bought.observeNext { _ in
            self.buildCellViewModels()
        }
        .dispose()
    }

    func saveItem() {
        var idString: String {
            return (self.item == nil) ? UUID().uuidString : item!.id
        }

        let adjustedItem = Item(
            name: finalName,
            id: idString,
            quantity: finalQuantity,
            duration: finalDuration,
            boughtStatus: finalBoughtStatus,
            dateAdded: item?.dateAdded ?? Date(),
            categoryID: finalCategoryID
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
        itemName.value = item?.name ?? ""
        itemQuantity.value = String(item?.quantity ?? 1)
        dateBought.value = (item?.dateBought ?? Date()).convertedToString()
        itemDuration.value = String(item?.duration ?? 7)
        bought.value = (item != nil && item?.boughtStatus != .notBought) ? false : true
        buildCellViewModels()
    }

    func replace(in array: [Item], with item: Item) {
        guard let originalItem = self.item else { return }
        let index = getItems.indexNumber(for: originalItem.id, in: array)
        var allItems = array
        allItems[index] = item
        getItems.save(allItems)
    }

    func observeInput() {
        let checkFields = merge(itemName, itemQuantity, dateBought, itemDuration)

        checkFields.observeNext { [weak self] _ in
            guard let name = self?.itemName.value,
                  let quantity = self?.itemQuantity.value,
                  let date = self?.dateFromString(self?.dateBought.value),
                  let duration = self?.itemDuration.value else { return }

            self?.isValid.value =
                name != "" &&
                quantity.isInt &&
                date <= Date() &&
                duration.isInt
        }
        .dispose(in: bag)
    }
}

// MARK: - Categories
extension DetailViewModel {
    func presentPopover(sender: UIButton) {
    coordinator.presentPopover(sender: sender, selectedIndex: selectedCategoryIndex)
    }
}

// MARK: - Date Info
extension DetailViewModel {
    func dateFromString(_ stringDate: String?) -> Date {
        guard let stringDate = stringDate else { return Date() }
        let format = DateFormatter()
        format.dateFormat = "MM/dd/yy"
        return format.date(from: stringDate) ?? Date()
    }
}

// MARK: - Unwrapped Binds
extension DetailViewModel {
    var finalName: String {
        guard let itemName = itemName.value else {
            fatalError("Failed to create item, name was nil")
        }
        return itemName
    }

    var finalQuantity: Int {
        guard let itemQuantity = itemQuantity.value else {
            fatalError("Failed to create item, quantity was nil")
        }
        return Int(itemQuantity) ?? 1
    }

    var finalDuration: Int {
        guard let duration = itemDuration.value else {
            fatalError("Failed to create item, duration was nil")
        }
        return Int(duration) ?? 7
    }

    var finalBoughtStatus: BoughtStatus {
        guard let bought = bought.value else {
            fatalError("Failed to create item, no bought status.")
        }
        guard let dateBought = dateBought.value else {
            fatalError("Failed to create item, no date bought selected")
        }
        guard bought == true else { return .notBought }
        let date = dateFromString(dateBought)
        return .bought(date)
    }

    var finalCategoryID: String? {
        return (selectedCategory != nil) ? selectedCategory?.id : nil
    }
}
