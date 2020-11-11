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

    @IBOutlet var dateWheel: UIDatePicker!
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
        self.hideKeyboardWhenTappedAround()
        super.viewDidLoad()
    }
}

extension DetailViewController {
    func tableSetUp() {
    tableView.isScrollEnabled = true
    tableView.separatorStyle = .none
    tableView.registerCellsForReuse([TextInputCell.self, SegmentedControlCell.self,
                                     DateCell.self, NumberInputCell.self, CategoryInputCell.self])
        viewModel.tableData.bind(to: tableView) { dataSource, indexPath, _ in
            let viewModel = dataSource[indexPath.row]
            switch viewModel {
            case let .nameInput(viewModel):
                return self.textInputCell(with: viewModel, at: indexPath)

            case let .boughtStatusInput(viewModel):
                return self.segmentedControlCell(with: viewModel, at: indexPath)

            case let .dateInput(viewModel):
                return self.dateInputCell(with: viewModel, at: indexPath)

            case let .numberInput(viewModel):
                return self.numberInputCell(with: viewModel, at: indexPath)

            case let .categoryInput(viewModel):
                return self.categoryInputCell(with: viewModel, at: indexPath)
            }
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
    saveButton.reactive.tap.bind(to: self) { $0.view.endEditing(true)
        $0.viewModel.saveItem() }
    viewModel.isValid.bind(to: saveButton.reactive.isEnabled)
    clearButton = UIBarButtonItem(title: "Clear",
                                  style: .plain,
                                  target: self,
                                  action: nil)
    clearButton.reactive.tap.bind(to: self) { $0.clearInput() }
    navigationItem.rightBarButtonItem = saveButton
    if viewModel.newItem == true {
      navigationItem.leftBarButtonItem = clearButton
    }
  }

  func clearInput() {
    viewModel.clearDetails()
  }
}

// MARK: - Cell Helper
extension DetailViewController {
    func textInputCell(with viewModel: TextInputCellViewModelType, at indexPath: IndexPath) -> TextInputCell {
        let cell = tableView.dequeueReusableCell(TextInputCell.self, for: indexPath)
        cell.viewModel = viewModel
        viewModel.validationSignal.observeNext { [weak self ] _ in
            self?.viewModel.observeValidationUpdates()
        }
        .dispose(in: cell.bag)
        return cell
    }

    func segmentedControlCell(with viewModel: SegmentedControlCellViewModelType, at indexPath: IndexPath) -> SegmentedControlCell {
        let cell = tableView.dequeueReusableCell(SegmentedControlCell.self, for: indexPath)
        cell.viewModel = viewModel
        return cell
    }

    func dateInputCell(with viewModel: DateCellViewModelType, at indexPath: IndexPath) -> DateCell {
        let cell = tableView.dequeueReusableCell(DateCell.self, for: indexPath)
        cell.viewModel = viewModel
        viewModel.validationSignal.observeNext { [weak self ] _ in
            self?.viewModel.observeValidationUpdates()
        }
        .dispose(in: cell.bag)
        return cell
    }

    func numberInputCell(with viewModel: NumberInputCellViewModelType, at indexPath: IndexPath) -> NumberInputCell {
        let cell = tableView.dequeueReusableCell(NumberInputCell.self, for: indexPath)
        cell.viewModel = viewModel
        viewModel.validationSignal.observeNext { [weak self ] _ in
            self?.viewModel.observeValidationUpdates()
        }
        .dispose(in: cell.bag)
        return cell
    }

    func categoryInputCell(with viewModel: CategoryInputCellViewModelType, at indexPath: IndexPath) -> CategoryInputCell {
        let cell = tableView.dequeueReusableCell(CategoryInputCell.self, for: indexPath)
        cell.viewModel = viewModel
        cell.inputButton.reactive.tapGesture().observeNext { _ in
            self.viewModel.presentPopover(selectedID: viewModel.updatedValue)
        }
        .dispose(in: cell.bag)
        return cell
    }
}
