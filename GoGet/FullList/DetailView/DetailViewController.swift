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
  var boughtDate: Date?
  @IBOutlet var intervalTextField: UITextField!
  var currentItem: Item?
  var itemNumber: Int?
  var newItem = false
  
    override func viewDidLoad() {
      manageTextFields()
      addDatePicker()
      addSaveButton()
      super.viewDidLoad()
    }
}

extension DetailViewController {
  func manageTextFields() {
    guard let item = currentItem else { return }
    itemTextField.text = item.name
    quantityTextField.text = String(item.quantity)
    boughtTextField.text = convertedDate(item.dateBought)
    intervalTextField.text = String(item.duration)
  }
}

extension DetailViewController {
  func addSaveButton() {
    let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveItem))
    navigationItem.rightBarButtonItem = saveButton
  }
  
  @objc func saveItem() {
    guard var item = currentItem else { return }
    item.name = itemTextField.text ?? ""
    item.quantity = Int(quantityTextField.text ?? "") ?? 1
    item.dateBought = boughtDate ?? Date()
    item.duration = Int(intervalTextField.text ?? "") ?? 7
    
    if newItem {
      allItems.append(item)
    } else {
      guard let indexNumber = itemNumber else { return }
      allItems[indexNumber] = item
    }
    save()
    confirmSave()
  }
  
  func save() {
    let json = JSONEncoder()
    if let savedData = try? json.encode(allItems) {
      let defaults = UserDefaults.standard
      defaults.set(savedData, forKey: "Items")
    } else {
      print("Failed to save")
    }
  }
  
  func confirmSave() {
    let saveConfirm = UIAlertController(title: "Item Saved", message: nil, preferredStyle: .alert)
    saveConfirm.addAction(UIAlertAction(title: "OK", style: .default, handler: backToFullList))
    present(saveConfirm, animated: true)
  }
  
  func backToFullList(action: UIAlertAction) {
    navigationController?.popViewController(animated: true)
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
