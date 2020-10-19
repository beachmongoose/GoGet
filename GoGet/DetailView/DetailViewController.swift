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
      textFieldBindings()
      addDatePicker()
      addSaveButton()
      super.viewDidLoad()
    }
}

// MARK: - Parse Data
extension DetailViewController {
  override func viewWillAppear(_ animated: Bool) {
    let item = viewModel.itemData
    itemTextField.text = item?.name ?? ""
    quantityTextField.text = item?.quantity ?? "1"
    dateTextField.text = item?.date ?? viewModel.convertedDate(Date())
    intervalTextField.text = item?.interval ?? "7"
    boughtBoolButton.selectedSegmentIndex = (item != nil) ? (item!.boughtBool ? 0 : 1): 0
    categoryButton.setTitle("None", for: .normal)
    super.viewWillAppear(animated)
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
    viewModel.saveItem()
    confirmSave(handler: changeTab(action:))
  }

  @objc func changeTab(action: UIAlertAction) {
    tabBarController?.selectedIndex = 0
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

}

// MARK: - Navigation

extension DetailViewController: UITabBarControllerDelegate {
  override func viewWillLayoutSubviews() {
    let title: String = (viewModel.item == nil) ? "New Item" : "Item Details"
    let navigationBar = self.navigation
    self.view.addSubview(navigation)
    let navigationItem = UINavigationItem(title: title)
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
