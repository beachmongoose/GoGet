//
//  DetailViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

class DetailViewController: UIViewController, UIPopoverPresentationControllerDelegate {
  var saveButton: UIBarButtonItem!
  var clearButton: UIBarButtonItem!
  @IBOutlet var navigation: UINavigationBar!
  @IBOutlet var itemTextField: UITextField!
  @IBOutlet var quantityTextField: UITextField!
  @IBOutlet var dateTextField: UITextField!
  @IBOutlet var intervalTextField: UITextField!
  @IBOutlet var boughtBoolButton: UISegmentedControl!
  @IBOutlet var categoryButton: UIButton!
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
      populateTextFields()
      textFieldBindings()
      addDatePicker()
      addNavigationButtons()
      boughtToggle()
      super.viewDidLoad()
    }
}

// MARK: - Populate Fields
extension DetailViewController {
  func populateTextFields() {
    itemTextField.text = viewModel.itemName.value
    quantityTextField.text = viewModel.itemQuantity.value
    dateTextField.text = viewModel.dateBought.value
    intervalTextField.text = viewModel.duration.value
    boughtBoolButton.selectedSegmentIndex = viewModel.bought.value ?? 1
    boughtFieldEnable((viewModel.bought.value == 0) ? true : false)
    categoryButton.setTitle(viewModel.selectedCategoryName.value, for: .normal)
  }

  func textFieldBindings() {
    itemTextField.reactive.text.bind(to: viewModel.itemName)
    quantityTextField.reactive.text.bind(to: viewModel.itemQuantity)
    dateTextField.reactive.text.bind(to: viewModel.dateBought)
    intervalTextField.reactive.text.bind(to: viewModel.duration)
    boughtBoolButton.reactive.selectedSegmentIndex.bind(to: viewModel.bought)
    viewModel.selectedCategoryName.observeNext { value in
      let category = (value != nil) ? value : "None"
      self.categoryButton.setTitle(category, for: .normal)
    }
    .dispose(in: bag)
    quantityTextField.keyboardType = .numberPad
    intervalTextField.keyboardType = .numberPad
  }
}

// MARK: - Saving
extension DetailViewController {
  func addNavigationButtons() {
    saveButton = UIBarButtonItem(title: "Save",
                                     style: .plain,
                                     target: self,
                                     action: nil)
    saveButton.reactive.tap.bind(to: self) { $0.viewModel.saveItem() }
    viewModel.isValid.bind(to: saveButton.reactive.isEnabled)
    clearButton = UIBarButtonItem(title: "Clear",
                                  style: .plain,
                                  target: self,
                                  action: nil)
    clearButton.reactive.tap.bind(to: self) { $0.clearInput() }
    navigationItem.rightBarButtonItem = saveButton
    if viewModel.item == nil {
      navigationItem.leftBarButtonItem = clearButton
    }
  }
}

// MARK: - Bought Button
extension DetailViewController {

  func boughtToggle() {
    boughtBoolButton.reactive.selectedSegmentIndex.observeNext { [weak self] _ in
      switch self?.boughtBoolButton.selectedSegmentIndex {
      case 0:
      self?.boughtFieldEnable(true)
      case 1:
      self?.boughtFieldEnable(false)
      default:
      break
      }
    }
    .dispose(in: bag)
  }
  func boughtFieldEnable(_ bool: Bool) {
    dateTextField.isUserInteractionEnabled = bool
    dateTextField.textColor = (bool) ? UIColor.black : UIColor.gray
  }
}

// MARK: - Date Info
extension DetailViewController {
  func addDatePicker() {
    let datePicker = UIDatePicker()
    datePicker.preferredDatePickerStyle = .wheels
    datePicker.datePickerMode = UIDatePicker.Mode.date

    datePicker.addTarget(self, action: #selector(DetailViewController.datePicked(sender:)),
                         for: UIControl.Event.valueChanged)
    dateTextField.inputView = datePicker
  }

  @objc func datePicked(sender: UIDatePicker) {
    dateTextField.text = viewModel.convertedDate(sender.date)
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    view.endEditing(true)
  }
}

// MARK: - Category List
extension DetailViewController {

  @IBAction func openCategories(_ sender: UIButton) {
    viewModel.presentPopover(sender: sender)
  }

  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
  return .none
  }

  func popoverPresentationControllerDidDismissPopover(
    _ popoverPresentationController: UIPopoverPresentationController) {
  }

  func popoverPresentationControllerShouldDismissPopover(
    _ popoverPresentationController: UIPopoverPresentationController) -> Bool {
  return true
  }

  func clearInput() {
    viewModel.getDetails()
    populateTextFields()
  }
}
