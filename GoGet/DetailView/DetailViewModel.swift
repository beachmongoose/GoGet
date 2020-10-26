//
//  DetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Bond
import ReactiveKit
import UIKit

protocol DetailViewModelType {
  func convertedDate(_ date: Date) -> String
  func presentPopover(sender: UIButton)
  func saveItem()
  func getDetails()
  var item: Item? { get }

// Data field bindings
  var itemName: Property<String?> { get }
  var itemQuantity: Property<String?> { get }
  var dateBought: Property<String?> { get }
  var duration: Property<String?> { get }
  var bought: Property<Int?> { get }
//
  var selectedCategoryName: Observable<String?> { get }
  var isValid: Property<Bool> { get }
}

//TODO: FORMAT AS TABLE
final class DetailViewModel: DetailViewModelType {
//  enum CellViewModel {
//    case textInputCell(TextInputCellViewModel)
//    case numberInputCell(TextInputCellViewModel)
//    case textInput(TextInputCellViewModel)
//    case textInput(TextInputCellViewModel)
//  }
  var item: Item?
  var newItemStatus: Bool {
    return item == nil
  }

  var categories: [Category] = []

// Data field bindings
  let itemName = Property<String?>(nil)
  let itemQuantity = Property<String?>(nil)
  let dateBought = Property<String?>(nil)
  let duration = Property<String?>(nil)
  let bought = Property<Int?>(nil)
//

  var selectedCategory: Category?
  let selectedCategoryIndex = Property<Int?>(nil)
  let selectedCategoryName = Observable<String?>(nil)

  let isValid = Property<Bool>(false)

  private let coordinator: DetailViewCoordinatorType
  private let getCategories: GetCategoriesType
  private let getItems: GetItemsType
  private let bag = DisposeBag()

  init(coordinator: DetailViewCoordinatorType,
       getCategories: GetCategoriesType = GetCategories(),
       getItems: GetItemsType = GetItems(),
       item: Item?
       ) {
    self.coordinator = coordinator
    self.getCategories = getCategories
    self.getItems = getItems
    self.item = item
    self.categories = getCategories.load()
    getDetails()
    observeInput()
    observeCategoryUpdates()
    observeCategorySelection()
  }

  func getDetails() {
    itemName.value = item?.name ?? ""
    itemQuantity.value = String(item?.quantity ?? 1)
    dateBought.value = convertedDate(item?.dateBought ?? Date())
    duration.value = String(item?.duration ?? 7)
    bought.value = (item != nil && item?.boughtStatus != .notBought) ? 0 : 1
    checkForCategory()
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

  //TODO: Promise
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
    getDetails()
  }

  func replace(in array: [Item], with item: Item) {
    guard let originalItem = self.item else { return }
    let index = getItems.indexNumber(for: originalItem.id, in: array)
    var allItems = array
    allItems[index] = item
    getItems.save(allItems)
  }

  func observeInput() {
    let checkFields = merge(itemName, itemQuantity, dateBought, duration)

    checkFields.observeNext { [weak self] _ in
      guard let name = self?.itemName.value,
            let quantity = self?.itemQuantity.value,
            let date = self?.dateFromString(self?.dateBought.value),
            let duration = self?.duration.value else { return }

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

  func checkForCategory() {
    guard item?.categoryID != nil else { selectedCategoryName.value = "None"
      return }
    let data = getCategories.forID((item?.categoryID)!)
    selectedCategoryIndex.value = data.0
    selectedCategory = data.1
    selectedCategoryName.value = selectedCategory?.name
  }

  func presentPopover(sender: UIButton) {
    coordinator.presentPopover(sender: sender, selectedIndex: selectedCategoryIndex)
  }

  func observeCategoryUpdates() {
    defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
      self.categories = self.getCategories.load()
    }
    .dispose(in: bag)
  }

  func observeCategorySelection() {
    selectedCategoryIndex.observeNext { index in
      let category = (self.categories.count == 0 || index == nil) ? nil : self.categories[index ?? 0]
      self.selectedCategory = category
      self.selectedCategoryName.value = category?.name ?? nil
    }
    .dispose(in: bag)
  }
}

// MARK: - Date Info
extension DetailViewModel {
  func convertedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    return formatter.string(from: date)
  }

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
    guard let duration = duration.value else {
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
    guard bought == 0 else { return .notBought }
    let date = dateFromString(dateBought)
    return .bought(date)
    }

  var finalCategoryID: String? {
    return (selectedCategory != nil) ? selectedCategory?.id : nil
  }
}
