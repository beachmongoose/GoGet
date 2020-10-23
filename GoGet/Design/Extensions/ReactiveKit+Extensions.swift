//
//  ReactiveKit+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/13/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation
import ReactiveKit
import Bond
import UIKit

extension ReactiveExtensions where Base: UIButton {
        var Title: Bond<String?> {
            return bond { button, text in
                let attributedString = NSAttributedString(string: text!)
              button.setAttributedTitle(attributedString, for: UIControl.State.normal)
            }
        }
    }

extension String {
  var isInt: Bool {
    guard let number = Int(self) else { return false }
    return (number > 0) ? true : false
  }
}
