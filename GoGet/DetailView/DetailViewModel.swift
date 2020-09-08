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
  var date: Date
  var quantity: Int
  var interval: Int
}

protocol DetailViewModelType {
  func dismissDetail()
  func itemData() -> DetailViewItem
  func convertedDate(_ date: Date) -> String
  func formattedDate(_ picked: UIDatePicker) -> String
  func dateFromString(_ stringDate: String) -> Date
  func saveItem(name: String?, boughtBool: Bool, date: Date?, quantity: String?, interval: String?)
}

final class DetailViewModel: DetailViewModelType {
  
  var item: Item?
  var isNew: Bool {
    if item == nil {
      return true
    } else {
      return false
    }
  }
  
  weak var viewController: DetailViewController?
  private let coordinator: DetailViewCoordinator
  private let getItems: GetItemsType
  
  init(coordinator: DetailViewCoordinator, getItems: GetItemsType = GetItems(), item: Item?)
  {
    
    self.coordinator = coordinator
    self.getItems = getItems
    self.item = item
  }
  
  
  func itemData() -> DetailViewItem {
    return DetailViewItem(
      name: item?.name ?? "",
      boughtBool: item?.bought ?? false,
      date: item?.dateBought ?? Date(),
      quantity: item?.quantity ?? 1,
      interval: item?.duration ?? 7)

  }
  
  func dismissDetail() {
    coordinator.dismissDetail()
  }
  
  func saveItem(name: String?, boughtBool: Bool, date: Date?, quantity: String?, interval: String?) {
    
    guard let name = name,
      let quantity = quantity,
      let date = date,
      let interval = interval else {
        print("error")
        return
        // coordinator.presentAlert()
    }
    
    let adjustedItem = Item(
      name: name,
      quantity: Int(quantity) ?? 0,
      dateBought: date,
      duration: Int(interval) ?? 0,
      bought: boughtBool)
    
    guard isNotFutureDate(adjustedItem) else { print("error")
      return
    }
    
    var allItems = getItems.load()
    
    if isNew {
      allItems.append(adjustedItem)
      getItems.save(allItems)
    } else {
      replace(in: allItems, with: adjustedItem)
    }
  }
  
  func replace(in array: [Item], with item: Item) {
    guard let originalItem = self.item else { return }
    var allItems = array
    let index = indexNumber(for: originalItem, in: array)
    allItems[index] = item
    getItems.save(allItems)
  }
  
  
  func indexNumber(for item: Item, in array: [Item]) -> Int {
    return array.firstIndex { $0.name == item.name} ?? 0
  }
  
  // MARK: - Date Info
  
  func convertedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    return formatter.string(from: date)
  }
  
  func formattedDate(_ picked: UIDatePicker) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    return formatter.string(from: picked.date)
  }
  
  func dateFromString(_ stringDate: String) -> Date {
    let format = DateFormatter()
    format.dateFormat = "MM/dd/yy"
    return format.date(from: stringDate) ?? Date()
  }
  
  func isNotFutureDate(_ item: Item) -> Bool {
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
