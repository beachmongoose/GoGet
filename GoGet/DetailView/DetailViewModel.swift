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

struct DetailViewItem {
  var name: String
  var id: String?
  var boughtBool: Bool
  var date: String
  var quantity: String
  var interval: String
  var category: String
}

protocol DetailViewModelType {
  func convertedDate(_ date: Date) -> String
  func convertPickerDate(_ picked: UIDatePicker) -> String
  func saveItem()
  func presentPopover(sender: UIButton)
  func prePopulate()
  var item: Item? { get }

// Data field bindings
  var itemData: DetailViewItem! { get }
  var itemName: Property<String?> { get }
  var itemQuantity: Property<String?> { get }
  var dateBought: Property<String?> { get }
  var duration: Property<String?> { get }
  var bought: Property<Int?> { get }
  var selectedCategoryName: Observable<String?> { get }
  var isValid: Signal<Bool, Never>? { get }
}

final class DetailViewModel: DetailViewModelType {

  var item: Item?
  var itemData: DetailViewItem!
  var newItemStatus: Bool {
    return item == nil
  }

  var selectedCategoryIndex = Property<Int?>(nil)
  var selectedCategory: Category?
  var selectedCategoryName = Observable<String?>(nil)
  var categories: [Category] = []

// Data field bindings
  let itemName = Property<String?>(nil)
  let itemQuantity = Property<String?>(nil)
  let dateBought = Property<String?>(nil)
  let duration = Property<String?>(nil)
  let bought = Property<Int?>(nil)

  private let coordinator: DetailViewCoordinatorType
  private let getItems: GetItemsType
  private let getCategories: GetCategoriesType
  private let bag = DisposeBag()
  var isValid: Signal<Bool, Never>?

  init(coordinator: DetailViewCoordinatorType,
       getItems: GetItemsType = GetItems(),
       getCategories: GetCategoriesType = GetCategories(),
       item: Item?
       ) {
    self.coordinator = coordinator
    self.getItems = getItems
    self.getCategories = getCategories
    self.item = item
    self.itemData = getDetails()
    self.categories = getCategories.load()
    self.isValid = validBind()
    observeCategoryUpdates()
    observeCategorySelection()
  }

  func observeCategoryUpdates() {
    defaults.reactive.keyPath("Categories", ofType: Data?.self, context: .immediateOnMain).ignoreNils().observeNext { _ in
      self.categories = self.getCategories.load()
    }
    .dispose(in: bag)
  }
  func getDetails() -> DetailViewItem {

    let category = checkForCategory()

    // TODO: REMOVE UNUSED CATEGORY BEFORE DETAIL SCREEN REAPPEARS
    return DetailViewItem(
      name: item?.name ?? "",
      id: item?.id ?? nil,
      boughtBool: (item != nil && item?.boughtStatus != .notBought) ? true : false,
      date: convertedDate(item?.dateBought ?? Date()),
      quantity: String(item?.quantity ?? 1),
      interval: String(item?.duration ?? 7),
      category: category
      )
  }

  func prePopulate() {
//    guard item != nil else { return }
//    guard let item = itemData else { return }
    let item = itemData
    itemName.value = item?.name ?? ""
    itemQuantity.value = item?.quantity ?? "1"
    dateBought.value = item?.date ?? convertedDate(Date())
    duration.value = item?.interval ?? "7"
    bought.value = ((item?.boughtBool) != nil) ? 0 : 1
  }

  func saveItem() {
    var idString: String {
      return (self.item == nil) ? newID() : item!.id
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
//    validate(adjustedItem)
    upSert(adjustedItem)
  }

  func newID() -> String {
    return UUID().uuidString
  }

  func upSert(_ item: Item) {
    var allItems = getItems.load()

    if self.item == nil {
      allItems.append(item)
      getItems.save(allItems)
    } else {
      replace(in: allItems, with: item)
    }
// TODO: MAKE TAB CONTROLLER GO BACK TO PREVIOUS TAB
      coordinator.confirmSave(newItemStatus)
      itemData = nil
  }

  func replace(in array: [Item], with item: Item) {
    guard let originalItem = self.item else { return }
    let index = getItems.indexNumber(for: originalItem.id, in: array)
    var allItems = array
    allItems[index] = item
    getItems.save(array)
  }

  func validBind() -> Signal<Bool, Never> {
    return combineLatest(itemName, itemQuantity, dateBought, duration) { [self] name, quantity, _, duration in
      guard name != nil && quantity != nil && duration != nil else { return false }
      return name != "" && finalName != "" &&
        quantity!.isInt && finalQuantity != 0 &&
        self.dateFromString(dateBought.value) <= Date() &&
        duration!.isInt && finalDuration != 0
    }
  }

  // MARK: - Date Info
  func convertedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    return formatter.string(from: date)
  }

  func convertPickerDate(_ picked: UIDatePicker) -> String {
    return convertedDate(picked.date)
  }

  func dateFromString(_ stringDate: String?) -> Date {
    guard let stringDate = stringDate else { return Date() }
    let format = DateFormatter()
    format.dateFormat = "MM/dd/yy"
    return format.date(from: stringDate) ?? Date()
  }

  func futureDateCheck(_ item: Item) -> Bool {
    let calendar = Calendar.autoupdatingCurrent
    let currentDate = calendar.startOfDay(for: Date())
    let dateBought = calendar.startOfDay(for: item.dateBought)
    return dateBought < currentDate
  }
}

// MARK: - Categories
extension DetailViewModel {

  func checkForCategory() -> String {
    guard item?.categoryID != nil else { return "None" }
    let data = getCategories.forID((item?.categoryID)!)
    selectedCategoryIndex.value = data.0
    selectedCategory = data.1
    selectedCategoryName.value = selectedCategory?.name
    return selectedCategoryName.value ?? "None"
  }

  func presentPopover(sender: UIButton) {
    coordinator.presentPopover(sender: sender, selectedIndex: selectedCategoryIndex)
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
