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
    return Int(self) != nil
  }
}
