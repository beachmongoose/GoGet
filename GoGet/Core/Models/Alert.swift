//
//  Alert.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/24/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

/// A means to hold information and functionality Alert
public struct Alert {

    /// A means to manage an action for Alert
    public struct Action {
        /// The title of the action’s button.
        public let title: String
        /// The block to execute after Action is selected.
        public let action: (() -> Void)?

        /// Initialize an Alert.Action.
        ///
        /// - Parameters:
        ///     - title: The title of the action’s button.
        ///     - action: The block to execute after Action is selected. Defaults to nil.
        public init(title: String,
                    action: (() -> Void)? = nil) {
            self.title = title
            self.action = action
        }
    }

    /// The title of the alert.
    public let title: String
    /// Descriptive text that provides more details about the reason for the alert.
    public let message: String?
    /// Alert.Action that acts as a cancel button.
    public let cancelAction: Action
    /// Array of Alert.Action of Alert.
    public let otherActions: [Action]

    public let style: UIAlertController.Style
    
    public let textField: Bool?

    /// Initialize an Alert.
    ///
    /// - Parameters:
    ///     - title: The title of the alert. Defaults to "".
    ///     - message: Descriptive text that provides more details about the reason for the alert. Defaults to "".
    ///     - cancelAction: Alert.Action that acts as a cancel button. Defaults to
    ///                     Action(title: "Dismiss", style: .cancel).
    ///     - otherActions: Array of Alert.Action of Alert. Defaults to []].
    ///
    /// - Note:
    ///     Having a separate variable for cancelAction enforces its existence and its placement. cancelAction will
    ///     always be the left-most action and when not set, will act as a means to dismiss the alert, in case
    ///     forgotten by the user.
    public init(title: String = "",
                message: String?,
                cancelAction: Action? = nil,
                otherActions: [Action] = [],
                style: UIAlertController.Style? = nil,
                textField: Bool? = nil) {
        self.title = title
        self.message = message

        if let cancelAction = cancelAction {
            self.cancelAction = cancelAction
        } else {
            self.cancelAction = otherActions.isEmpty ? Action(title: "Dismiss") : Action(title: "Cancel")
        }

        self.otherActions = otherActions

        if let style = style {
            self.style = style
        } else {
            self.style = UIAlertController.Style.alert
        }

        if let textField = textField {
            self.textField = textField
        } else {
            self.textField = false
        }
    }
}

// MARK: - Equatable
extension Alert: Equatable {}
/// The `Equatable` function for `Alert`
public func == (lhs: Alert, rhs: Alert) -> Bool {
    lhs.title == rhs.title
        && lhs.message == rhs.message
        && lhs.cancelAction == rhs.cancelAction
        && lhs.otherActions == rhs.otherActions
}

extension Alert.Action: Equatable {}
/// The `Equatable` function for `Alert.Action`
public func == (lhs: Alert.Action, rhs: Alert.Action) -> Bool {
    lhs.title == rhs.title
}
