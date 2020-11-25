//
//  AlertController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/24/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit
import UIKit

/// A public interface to help mock UIAlertController presentation.
protocol AlertPresenter: AnyObject {
    /// UIAlertController to present. This value should only directly be referenced when mocking a UIAlertController in tests.
    var alertController: UIAlertController { get set }
}

extension AlertPresenter where Self: UIViewController {
    /// Present alertController on UIViewController.
    ///
    /// - Parameters:
    ///     - model: Alert with detail to present UIAlertController.
    ///     - view: UIView to display UIAlertController on. If nil, will display it on UIViewController.view. Defaults
    ///             to nil.
    func show(alert model: Alert, from view: UIView? = nil) {
        alertController = buildAlertController(with: model)
        alertController.title = model.title
        alertController.message = model.message

        if let view = view {
            alertController.popoverPresentationController?.sourceView = view
            alertController.popoverPresentationController?.sourceRect = view.bounds
        }

        present(alertController, animated: true)
    }
}

// MARK: - Alert Helper Methods
extension UIViewController {

    func buildAlertController(with model: Alert) -> UIAlertController {
        let alertController = UIAlertController(title: model.title, message: model.message, preferredStyle: model.style)
        let actions: [Alert.Action] = model.otherActions + [model.cancelAction]
        actions.map(UIAlertAction.init).forEach(alertController.addAction(_:))

        switch model.textFieldData {
        case .no:
            return alertController
        case let .yes(textInput):
            alertController.addTextField()
            let ok = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
                guard let name = alertController?.textFields?[0].text else { return }
                textInput.value = name
            }
            alertController.addAction(ok)
        return alertController
        default:
            return alertController
        }
    }
}

// MARK: - UIAlertAction Helper Init
extension UIAlertAction {
    convenience init(action: Alert.Action) {
        self.init(title: action.title, style: .default) { _ in
            action.action?()
        }
    }
}
