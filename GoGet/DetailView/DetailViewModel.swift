//
//  DetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Foundation
import UIKit

struct DetailViewItem {
  var name: String
  var boughtBool: Bool
  var date: String
  var quantity: String
  var interval: String
}

protocol DetailViewModelType {
  func convertedDate(_ date: Date) -> String
  func convertPickerDate(_ picked: UIDatePicker) -> String
  func saveItem(name: String?,
                bought: Int,
                date: String?,
                quantity: String?,
                interval: String?)
  var itemData: DetailViewItem! { get }
}

final class DetailViewModel: DetailViewModelType {
  
  var item: Item?
  
  weak var viewController: DetailViewController?
  private let coordinator: DetailViewCoordinatorType
  private let getItems: GetItemsType
  private var sortType: SortType = .added
  var itemData: DetailViewItem!
  var completion: () -> Void
  
  init(coordinator: DetailViewCoordinatorType,
       getItems: GetItemsType = GetItems(),
       item: Item?,
       completion: @escaping () -> Void)
  {
    self.coordinator = coordinator
    self.getItems = getItems
    self.item = item
    self.completion = completion
    self.itemData = getDetails()
  }
  
  
  func getDetails() -> DetailViewItem {
    
    var date: Date {
      get {
        guard item?.bought == true else { return Date() }
      return item?.dateBought ?? Date()
      }
    }
    
    return DetailViewItem(
      name: item?.name ?? "",
      boughtBool: item?.bought ?? false,
      date: convertedDate(date),
      quantity: String(item?.quantity ?? 1),
      interval: String(item?.duration ?? 7)
      )
  }
  
  func saveItem(name: String?,
                bought: Int,
                date: String?,
                quantity: String?,
                interval: String?) {
    
    guard let name = name,
      let quantity = quantity,
      let date = date,
      let interval = interval else {
        coordinator.errorMessage("Invalid data.")
        return
    }
    
    let adjustedItem = Item(
      name: name,
      quantity: Int(quantity) ?? 1,
      dateBought: dateFromString(date),
      duration: Int(interval) ?? 7,
      bought: bought == 0,
      dateAdded: item?.dateAdded ?? Date()
    )
    
    validate(adjustedItem)
  }
  
  func upSert(_ item: Item) {
    var allItems = getItems.load(orderBy: sortType)
    
    if self.item == nil {
      allItems.append(item)
      getItems.save(allItems)
    } else {
      replace(in: allItems, with: item)
    }
    completion()
    coordinator.confirmSave()
  }
  
  func replace(in array: [Item], with item: Item) {
    guard let originalItem = self.item else { return }
    var allItems = array
    let index = getItems.indexNumber(for: originalItem, in: array)
    allItems[index] = item
    getItems.save(allItems)
  }
  
  func validate(_ item: Item) {
    switch item {
    case (let item) where item.quantity == 0:
      return coordinator.errorMessage("No quantity entered.")
    case (let item) where item.duration == 0:
      return coordinator.errorMessage("No duration entered.")
    case (let item) where item.dateBought > Date():
      return coordinator.errorMessage("Future date selected.")
//    case (let item) where item.name == self.item?.name:
//      return coordinator.errorMessage("Duplicate item.")
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
    if dateBought > currentDate {
      return false
    } else {
      return true
    }
  }
  
}
