//
//  UIViewController+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/14/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentCategoryOptions(handler: ((UIAlertAction, SelectedOption) -> Void)?) {
        let optionsController = UIAlertController(title: "Options", message: nil, preferredStyle: .alert)
        let renameOption = UIAlertAction(title: "Rename", style: .default) { action in
            let type: SelectedOption = .rename
            handler!(action, type)
        }
        let deleteOption = UIAlertAction(title: "Delete", style: .default) { action in
            let type: SelectedOption = .delete
            handler!(action, type)
        }
        optionsController.addAction(renameOption)
        optionsController.addAction(deleteOption)
        optionsController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(optionsController, animated: true)
    }

    func presentRename(handler: ((UIAlertAction, String) -> Void)?) {
        let renameController = UIAlertController(title: "Enter Category Name", message: nil, preferredStyle: .alert)
        renameController.addTextField()
        let submitNewName = UIAlertAction(title: "OK", style: .default) { [weak renameController] action in
            guard let category = renameController?.textFields?[0].text else { return }
            handler!(action, category)
        }
        renameController.addAction(submitNewName)
        renameController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(renameController, animated: true)
    }

    func presentDeleteAlert(handler: ((UIAlertAction) -> Void)?) {
        let deleteController = UIAlertController(title: "Delete Category?", message: nil, preferredStyle: .alert)
        deleteController.addAction(UIAlertAction(title: "Yes", style: .default, handler: handler))
        deleteController.addAction(UIAlertAction(title: "No", style: .cancel))
        present(deleteController, animated: true)
    }

    func presentBoughtAlert(handler: ((UIAlertAction) -> Void)?) {
        let markBoughtPrompt = UIAlertController(title: "Mark as Bought?", message: nil, preferredStyle: .alert)
        markBoughtPrompt.addAction(UIAlertAction(title: "Yes", style: .default, handler: handler))
        markBoughtPrompt.addAction(UIAlertAction(title: "No", style: .cancel))
        present(markBoughtPrompt, animated: true)
    }

    func presentSortOptions(handler: ((UIAlertAction) -> Void)?) {
        let sortController = UIAlertController(title: "Sort by...", message: nil, preferredStyle: .actionSheet)
        sortController.addAction(UIAlertAction(title: checkIfSelected("Name"), style: .default, handler: handler))
        sortController.addAction(UIAlertAction(title: checkIfSelected("Date"), style: .default, handler: handler))
        sortController.addAction(UIAlertAction(title: checkIfSelected("Added"), style: .default, handler: handler))
        sortController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sortController, animated: true)
    }

    func presentConfirmRequest(handler: ((UIAlertAction) -> Void)?) {
        let confirmController = UIAlertController(title: "Confirm Delete?", message: nil, preferredStyle: .alert)
        confirmController.addAction(UIAlertAction(title: "Yes", style: .default, handler: handler))
        confirmController.addAction(UIAlertAction(title: "No", style: .cancel))
        present(confirmController, animated: true)
    }

    func checkIfSelected(_ title: String) -> String {
        let sortTypeInstance: SortingInstanceType = SortingInstance.shared
        guard sortTypeInstance.sortType == SortType(rawValue: title.lowercased()) else {
            return "\(title) ↑" }
        return (sortTypeInstance.sortAscending == true) ? "\(title) ↓" : "\(title) ↑"
    }

    func addCategory(handler: ((UIAlertAction, String) -> Void)?) {
        let newCategoryController = UIAlertController(title: "Enter Category Name", message: nil, preferredStyle: .alert)
        newCategoryController.addTextField()
        let submitCategory = UIAlertAction(title: "OK", style: .default) { [weak newCategoryController] action in
            guard let category = newCategoryController?.textFields?[0].text else { return }
            handler!(action, category)
        }
        newCategoryController.addAction(submitCategory)
        newCategoryController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(newCategoryController, animated: true)
    }

    func presentError(message: String) {
        let errorAlert = UIAlertController(title: "Error", message: "\(message)", preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(errorAlert, animated: true)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
