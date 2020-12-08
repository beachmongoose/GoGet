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

extension UIView {
    static func fromNib<View: UIView>() -> View {
        let bundle = Bundle(for: self)
        let nib = bundle.loadNibNamed(String(describing: self), owner: nil, options: nil)
        let subject = nib!.first as? View
        return subject!
    }

    class func cellFromNib<T: UIView>() -> T {
        (Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as? T)!
    }
}
