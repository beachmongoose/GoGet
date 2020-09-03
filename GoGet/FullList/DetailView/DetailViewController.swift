//
//  DetailViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
  var allItems = [Item]()
  @IBOutlet var itemTextField: UITextField!
  @IBOutlet var quantityTextField: UITextField!
  @IBOutlet var boughtTextField: UITextField!
  @IBOutlet var yesButton: UIButton!
  @IBOutlet var noButton: UIButton!
  var boughtDate: Date?
  @IBOutlet var intervalTextField: UITextField!
  var currentItem: Item?
  var itemNumber: Int?
  var newItem = false

  private let getItems: GetItemsType = GetItems()
  
  override func viewDidLoad() {
      manageTextFields()
      addDatePicker()
      addSaveButton()
      super.viewDidLoad()
    }
}

// MARK: - Parse Data
extension DetailViewController {
  func manageTextFields() {
    guard let item = currentItem else { return }
    itemTextField.text = item.name
    quantityTextField.text = String(item.quantity)
    boughtTextField.text = convertedDate(item.dateBought)
    intervalTextField.text = String(item.duration)
    
    if item.bought == false {
      checkNo(self)
      } else {
      checkYes(self)
      }
    }
}

// MARK: - Saving
extension DetailViewController {
  func addSaveButton() {
    let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveItem))
    navigationItem.rightBarButtonItem = saveButton
  }
  
  @objc func saveItem() {
    guard var item = currentItem else { return }
    guard isNotFutureDate() else {
      dateError()
      return
    }
    item.name = itemTextField.text ?? ""
    item.quantity = Int(quantityTextField.text ?? "") ?? 1
    
    if item.bought == true {
    item.dateBought = boughtDate ?? Date()
    } else {
      item.dateBought = Date()
    }
    
    item.duration = Int(intervalTextField.text ?? "") ?? 7
    
    if newItem {
      allItems.append(item)
    } else {
      guard let indexNumber = itemNumber else { return }
      allItems[indexNumber] = item
    }
    getItems.save(self.allItems)
    confirmSave()
  }
  
  func confirmSave() {
    let saveConfirm = UIAlertController(title: "Item Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      self.navigationController?.popViewController(animated: true)
    }))
    present(saveConfirm, animated: true)
  }

}

// MARK: - Bought Buttons
extension DetailViewController {
  @IBAction func checkYes(_ sender: Any) {
    adjustButtons(yes: "circle.fill",
                  no: "circle",
                  enabled: true,
                  textColor: UIColor.black,
                  bought: true)
  }
  
  @IBAction func checkNo(_ sender: Any) {
    adjustButtons(yes: "circle",
                  no: "circle.fill",
                  enabled: false,
                  textColor: UIColor.gray,
                  bought: false)

  }
  
  func adjustButtons(yes yesSymbol: String,
                     no noSymbol: String,
                     enabled textBool: Bool,
                     textColor color: UIColor,
                     bought boughtBool: Bool) {
    markButton(yesButton, with: yesSymbol)
    markButton(noButton, with: noSymbol)
    boughtTextField.isUserInteractionEnabled = textBool
    boughtTextField.textColor = color
    currentItem?.bought = boughtBool
  }
  
  func markButton(_ button: UIButton, with symbol: String) {
    button.setImage(UIImage(systemName: symbol), for: .normal)
  }
}

// MARK: - Date Info
extension DetailViewController {
  func addDatePicker() {
    let datePicker = UIDatePicker()
    datePicker.datePickerMode = UIDatePicker.Mode.date
    
    datePicker.addTarget(self, action: #selector(DetailViewController.datePicked(sender:)),
                         for: UIControl.Event.valueChanged)
    boughtTextField.inputView = datePicker
  }
  
  @objc func datePicked(sender: UIDatePicker) {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    boughtDate = sender.date
    boughtTextField.text = formatter.string(from: sender.date)
  }
  
  func isNotFutureDate() -> Bool {
    let calendar = Calendar.autoupdatingCurrent
    let currentDate = calendar.startOfDay(for: Date())
    let dateBought = calendar.startOfDay(for: boughtDate ?? Date())
    if dateBought > currentDate {
      return false
    } else {
      return true
    }
  }
  
  func dateError() {
      let dateError = UIAlertController(title: "Error", message: "Future date selected", preferredStyle: .alert)
    dateError.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(dateError, animated: true)
    }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
  
  func convertedDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.short
    formatter.timeStyle = DateFormatter.Style.none
    return formatter.string(from: date)
  }
}
