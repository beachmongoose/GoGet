//
//  DetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Foundation
import UIKit
import Bond
import ReactiveKit

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
  var item: Item? { get }
  var itemData: DetailViewItem! { get }
  func isDuplicate(_ entry: String?) -> Bool
  func fetchDropDownList() -> [String]
  func dropDownIndex(for category: String) -> Int
  var itemName: Property<String?> { get }
  var itemQuantity: Property<String?> { get }
  var dateBought: Property<String?> { get }
  var duration: Property<String?> { get }
  var bought: Property<Int?> { get }
  var categoryName: Property<CategoryID?> { get }
}

final class DetailViewModel: DetailViewModelType {

  weak var viewController: DetailViewController?
  private let coordinator: DetailViewCoordinatorType
  private let getItems: GetItemsType
  private let getCategories: GetCategoriesType
  var item: Item?
  var itemData: DetailViewItem!
  var categories = [Category]()
  private var sortType: SortType = .added
  let itemName = Property<String?>(nil)
  var itemQuantity = Property<String?>(nil)
  var dateBought = Property<String?>(nil)
  var duration = Property<String?>(nil)
  var bought = Property<Int?>(nil)
  var categoryName = Property<CategoryID?>(nil)

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
  }

  func getDetails() -> DetailViewItem {
    var date: Date {
      guard item?.bought == true else { return Date() }
      return item?.dateBought ?? Date()
    }
    
    

    return DetailViewItem(
      name: item?.name ?? "",
      id: item?.id ?? nil,
      boughtBool: item?.bought ?? false,
      date: convertedDate(date),
      quantity: String(item?.quantity ?? 1),
      interval: String(item?.duration ?? 7),
      category: String(getName(for: item?.categoryID ?? ""))
      )
  }

  func saveItem() {
    var idString: String {
      return (self.item == nil) ? newID() : item!.id
    }

    let adjustedItem = Item(
      name: finalName,
      quantity: finalQuantity,
      dateBought: Date
      dateBought: dateFromString(dateBought.value),
      duration: Int(duration) ?? 7,
      bought: bought == 0,
      dateAdded: item?.dateAdded ?? Date(),
      id: idString,
      categoryID: getID(for: categoryName)
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
    case (let item) where item.dateBought ?? Date() > Date():
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
    let dateBought = calendar.startOfDay(for: item.dateBought ?? Date())
    return dateBought < currentDate
  }

// MARK: - Categories

  func getID(for name: String) -> CategoryID? {
    guard name != "" else { return nil }
    for category in categories where name == category.name {
      return category.id
    }
    return getCategories.createCategory(for: name)
  }

  func getName(for categoryID: String) -> String {
    var name = ""
    let categories = getCategories.load()
    for category in categories where categoryID == category.id {
      name = category.name
    }
    return name
  }

  func fetchCategoryData() {
    categories = getCategories.load()
  }

  func fetchDropDownList() -> [String] {
    var dropDownList = categories.reduce(into: [String]()) { array, category in
      array.append(category.name)
    }
    dropDownList.insert("--Select--", at: 0)
    dropDownList.append("--Add New--")
    return dropDownList
  }

  func dropDownIndex(for category: String) -> Int {
    guard category != "" else { return 0 }
    let list = fetchDropDownList()
    return list.firstIndex(where: {$0.lowercased() == category}) ?? 0
  }

  func isDuplicate(_ entry: String?) -> Bool {
    return getCategories.checkIfDuplicate(entry)
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
      fatalError("Failed to enter quantity, quantity was nil")
    }
    return Int(itemQuantity) ?? 1
  }
  var finalBoughtDate: Date {
    guard let dateBought = dateBought.value else {
      fatalError("Failed to enter date bought, no date found")
    }
    
  }
}
