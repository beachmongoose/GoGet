//
//  DetailViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//
import Foundation

protocol DetailViewModelType {
  func dismissDetail()
  func populateDetails(for item: Item)
  var item: Item { get }
}

final class DetailViewModel: DetailViewModelType {
  
  weak var viewController: DetailViewController?
  
  private let coordinator: DetailViewCoordinator
  private let getItems: GetItemsType
  
  var item: Item?
  var itemName: String
  var adjustedItem: Item
  
  init(coordinator: DetailViewCoordinator, getItems: GetItemsType = GetItems(), item: Item?, adjustedItem: Item)
  {
    self.coordinator = coordinator
    self.getItems = getItems
    self.item = item
    self.itemName = item?.name
  }
  
  
  func populateDetails(for item: Item){
//    viewController?.itemTextField.text = item.name
      viewController?.quantityTextField.text = String(item.quantity)
      viewController?.dateTextField.text = convertedDate(item.dateBought)
      viewController?.intervalTextField.text = String(item.duration)
    }
  }
  
  func convertedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    return formatter.string(from: date)
  }
  
  func dismissDetail() {
    coordinator.dismissDetail()
  }
  
  func save(allItems: [Item]) {
//    guard let item = item else { return }
//    var allItems = getItems.load()
//    for entry in allItems {
//      if item == entry {
//
//      }
//    }
  }
  
}
