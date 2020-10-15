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

  var item: Item? { get }
// ^ may not need anymore

// Data field bindings
  var itemData: DetailViewItem! { get }
  var itemName: Property<String?> { get }
  var itemQuantity: Property<String?> { get }
  var dateBought: Property<String?> { get }
  var duration: Property<String?> { get }
  var bought: Property<Int?> { get }
  var selectedCategoryName: Observable<String?> { get }
}

final class DetailViewModel: DetailViewModelType {

  var item: Item?
// ^ may not need anymore

  var itemData: DetailViewItem!

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
    observeCategoryUpdates()
    observeCategorySelection()
  }

  func observeCategoryUpdates() {
    defaults.reactive.keyPath("Categories", ofType: Data.self, context: .immediateOnMain).observeNext { _ in
      self.categories = self.getCategories.load()
    }
    .dispose(in: bag)
  }
  func getDetails() -> DetailViewItem {

    let category = checkForCategory()

    return DetailViewItem(
      name: item?.name ?? "",
      id: item?.id ?? nil,
      boughtBool: (item != nil || item?.boughtStatus != .notBought) ? true : false,
      date: convertedDate(item?.dateBought ?? Date()),
      quantity: String(item?.quantity ?? 1),
      interval: String(item?.duration ?? 7),
      category: category
      )
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
    validate(adjustedItem)
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
// make tab controller change tabs to original
    coordinator.confirmSave()
  }

  func replace(in array: [Item], with item: Item) {
    guard let originalItem = self.item else { return }
    var allItems = array
    let index = getItems.indexNumber(for: originalItem.name, in: array)
    allItems[index] = item
    getItems.save(allItems)
  }

  func validate(_ item: Item) {

    switch item {
    case (let item) where item.quantity == 0:
      return coordinator.errorMessage("No quantity entered.")
    case (let item) where item.duration == 0:
      return coordinator.errorMessage("No duration entered.")
    case ( _) where item.dateBought > Date():
      return coordinator.errorMessage("Future date selected.")
    case (let item) where item.name == "":
      return coordinator.errorMessage("No name entered.")
    case (let item) where getItems.isDuplicate(item.name):
      if self.item != nil {
        break
      } else {
        return coordinator.errorMessage("Item already exists.") }
    default:
      break
    }
    upSert(item)
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

  func dateFromString(_ stringDate: String) -> Date {
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
    guard item?.categoryID != nil else { return "" }
    let data = getCategories.forID((item?.categoryID)!)
    selectedCategoryIndex.value = data.0
    selectedCategory = data.1
    selectedCategoryName.value = selectedCategory?.name
    return selectedCategoryName.value ?? ""
  }

  func presentPopover(sender: UIButton) {
    coordinator.presentPopover(sender: sender, selectedIndex: selectedCategoryIndex)
  }

  func observeCategorySelection() {
    selectedCategoryIndex.observeNext { index in
      let category = (self.categories.count == 0) ? nil : self.categories[index ?? 0]
      self.selectedCategory = category
      self.selectedCategoryName.value = category?.name
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
