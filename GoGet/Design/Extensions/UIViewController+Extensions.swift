//
//  UIViewController+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/14/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

extension UIViewController {

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
