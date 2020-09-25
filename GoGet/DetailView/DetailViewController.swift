//
//  DetailViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit
import iOSDropDown
import Foundation

class DetailViewController: UIViewController {
  @IBOutlet var navigation: UINavigationBar!
  @IBOutlet var itemTextField: UITextField!
  @IBOutlet var quantityTextField: UITextField!
  @IBOutlet var dateTextField: UITextField!
  @IBOutlet var intervalTextField: UITextField!
  @IBOutlet var boughtBoolButton: UISegmentedControl!
  @IBOutlet var dropDownField: DropDown!
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
      itemTextField.reactive.text.bind(to: viewModel.itemName)
      populateTextFields()
      addDatePicker()
      addSaveButton()
      dropDownMenu()
      super.viewDidLoad()
    }
}

// MARK: - Parse Data
extension DetailViewController {
  func populateTextFields() {
    guard let item = viewModel.itemData else { return }
    itemTextField.text = item.name
    quantityTextField.text = item.quantity
    dateTextField.text = item.date
    intervalTextField.text = item.interval
    boughtBoolButton.selectedSegmentIndex = item.boughtBool ? 0 : 1
    dropDownField.text = (item.category.isEmpty) ? "--Select--" : item.category
    buttonChanged(self)
  }

  func dropDownMenu() {
    dropDownField.optionArray = viewModel.fetchDropDownList()
    dropDownField.selectedRowColor = UIColor.white
  }

}

// MARK: - Saving
extension DetailViewController {
  func addSaveButton() {
    let saveButton = UIBarButtonItem(title: "Save",
                                     style: .plain,
                                     target: self,
                                     action: #selector(saveItem))
    navigationItem.rightBarButtonItem = saveButton
  }

  @objc func saveItem() {
    let categoryText = (dropDownField.text == "--Select--") ? "" : dropDownField.text

    viewModel.saveItem(
      name: itemTextField.text,
      bought: boughtBoolButton.selectedSegmentIndex,
      date: dateTextField.text,
      quantity: quantityTextField.text,
      interval: intervalTextField.text,
      category: categoryText
    )
  }
}

// MARK: - Bought Buttons
extension DetailViewController {
  @IBAction func buttonChanged(_ sender: Any) {
    switch boughtBoolButton.selectedSegmentIndex {
    case 0:
      updateBoughtField(enabled: true,
                    textColor: UIColor.black)
    case 1:
      updateBoughtField(enabled: false,
                    textColor: UIColor.gray)
    default:
      break
    }
  }
  func updateBoughtField(enabled bool: Bool,
                         textColor color: UIColor) {
    dateTextField.isUserInteractionEnabled = bool
    dateTextField.textColor = color
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

// MARK: - Category
extension DetailViewController {

  @IBAction func addCategory(_ sender: Any) {
    addCategory(handler: populateCategoryField)
  }

  func populateCategoryField(action: UIAlertAction, category: String?) {
    guard category != nil || category != "--Select--" else { presentError(message: "Name not entered")
      return }
    if viewModel.isDuplicate(category) { presentError(message: "Category already exists")}
    dropDownField.text = category
  }
}

// MARK: - Navigation

extension DetailViewController: UITabBarControllerDelegate {
  override func viewWillLayoutSubviews() {
    let navigationBar = self.navigation
    self.view.addSubview(navigation)
    let navigationItem = UINavigationItem(title: "Navigation Bar")
    let saveButton = UIBarButtonItem(title: "Save",
                                     style: .plain,
                                     target: self,
                                     action: #selector(saveItem))
    navigationItem.rightBarButtonItem = saveButton
    navigationBar!.setItems([navigationItem], animated: false)
  }

  func dismiss() {
    self.tabBarController!.selectedIndex = 0
  }
}
