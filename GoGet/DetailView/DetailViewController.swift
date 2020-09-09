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
  @IBOutlet var dateTextField: UITextField!
  @IBOutlet var yesButton: UIButton!
  @IBOutlet var noButton: UIButton!
  var boughtFlag = false
  @IBOutlet var intervalTextField: UITextField!

  private let getItems: GetItemsType = GetItems()
  private let viewModel: DetailViewModelType
  
  init(viewModel: DetailViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
    guard let item = viewModel.itemData else { return }
    itemTextField.text = item.name
    quantityTextField.text = item.quantity
    dateTextField.text = item.date
    intervalTextField.text = item.interval
    
    if !item.boughtBool{
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
    viewModel.saveItem(
      name: itemTextField.text,
      boughtBool: boughtFlag,
      date: dateTextField.text,
      quantity: quantityTextField.text,
      interval: intervalTextField.text)
    }

}
// MARK: - Bought Buttons
extension DetailViewController {
  @IBAction func checkYes(_ sender: Any) {
    adjustButtons(yes: "circle.fill",
                  no: "circle",
                  enabled: true,
                  textColor: UIColor.black)
  }
   
  @IBAction func checkNo(_ sender: Any) {
    adjustButtons(yes: "circle",
                  no: "circle.fill",
                  enabled: false,
                  textColor: UIColor.gray)

  }
  
  func adjustButtons(yes yesSymbol: String,
                     no noSymbol: String,
                     enabled bool: Bool,
                     textColor color: UIColor
                     ) {
    markButton(yesButton, with: yesSymbol)
    markButton(noButton, with: noSymbol)
    boughtFlag = bool
    dateTextField.isUserInteractionEnabled = bool
    dateTextField.textColor = color
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
    dateTextField.inputView = datePicker
  }
  
  @objc func datePicked(sender: UIDatePicker) {
    dateTextField.text = viewModel.convertPickerDate(sender)
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}
