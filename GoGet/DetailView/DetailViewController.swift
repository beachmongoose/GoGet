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
  private let viewModel: DetailViewModelType
  @IBOutlet var tableView: UITableView!

  init(viewModel: DetailViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    tableSetUp()
    addNavigationButtons()
      super.viewDidLoad()
    }
}

extension DetailViewController {
    func tableSetUp() {
    tableView.isScrollEnabled = false
    tableView.separatorStyle = .none
    tableView.registerCellsForReuse([TextInputCell.self, SegmentedControlCell.self,
                                        DateCell.self, NumberInputCell.self, CategoryInputCell.self])
        viewModel.tableData.bind(to: tableView) { dataSource, indexPath, tableView in
            let viewModel = dataSource[indexPath.row]
            switch viewModel {
            case let .nameInput(viewModel):
                let cell = tableView.dequeueReusableCell(TextInputCell.self, for: indexPath)
                cell.viewModel = viewModel
                viewModel.validationSignal.observeNext { [weak self ] _ in
                    self?.viewModel.observeValidationUpdates()
                }
                .dispose(in: self.bag)
                return cell

            case let .boughtStatusInput(viewModel):
                let cell = tableView.dequeueReusableCell(SegmentedControlCell.self, for: indexPath)
                cell.viewModel = viewModel
                return cell

            case let .dateInput(viewModel):
                let cell = tableView.dequeueReusableCell(DateCell.self, for: indexPath)
                cell.viewModel = viewModel
                viewModel.validationSignal.observeNext { [weak self ] _ in
                    self?.viewModel.observeValidationUpdates()
                }
                .dispose(in: self.bag)
                return cell

            case let .numberInput(viewModel):
                let cell = tableView.dequeueReusableCell(NumberInputCell.self, for: indexPath)
                cell.viewModel = viewModel
                viewModel.validationSignal.observeNext { [weak self ] _ in
                    self?.viewModel.observeValidationUpdates()
                }
                .dispose(in: self.bag)
                return cell

            case let .categoryInput(viewModel):
                let cell = tableView.dequeueReusableCell(CategoryInputCell.self, for: indexPath)
                cell.viewModel = viewModel
                cell.inputButton.reactive.tapGesture().observeNext { _ in
                    self.viewModel.presentPopover(sender: cell.inputButton, id: viewModel.updatedValue)
                }
                .dispose(in: self.bag)
                return cell
        }
//     tableView.delegate = self
        }
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

  func clearInput() {
    viewModel.clearDetails()
  }
}
