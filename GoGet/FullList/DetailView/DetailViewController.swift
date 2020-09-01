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
  @IBOutlet var itemTextField: UITextField!
  @IBOutlet var quantityTextField: UITextField!
  @IBOutlet var boughtTextField: UITextField!
  var boughtDate: Date?
  @IBOutlet var intervalTextField: UITextField!
  var currentItem: Item?
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
    guard !newItem else { return }
    itemTextField.text = item.name
    quantityTextField.text = String(item.quantity)
    boughtDate = item.dateBought
    intervalTextField.text = String(item.duration)
  }
}

extension DetailViewController {
  func addSaveButton() {
  let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveItem))
  navigationItem.rightBarButtonItem = saveButton
  }
  
  @objc func saveItem() {
    currentItem?.name = itemTextField.text ?? ""
    currentItem?.quantity = Int(quantityTextField.text ?? "") ?? 1
    currentItem?.dateBought = boughtDate ?? Date()
    currentItem?.duration = Int(intervalTextField.text ?? "") ?? 7
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
}
