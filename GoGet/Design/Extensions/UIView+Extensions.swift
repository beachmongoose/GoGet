//
//  UIView+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

extension UIView {
    // Returns a string of the given UIView class
    public static var reuseIdentifier: String {
        String(describing: self)
    }

    // Returns a nib for the given UIView class, defaults bundle to nil
    public static func nib(bundle: Bundle? = nil) -> UINib {
        UINib(nibName: reuseIdentifier, bundle: bundle)
    }
}
