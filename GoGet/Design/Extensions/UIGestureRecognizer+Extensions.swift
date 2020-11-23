//
//  UIGestureRecognizer+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/23/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

extension UIGestureRecognizer {
    func tap() {
        setValue(UITapGestureRecognizer.State.began.rawValue, forKey: "state")
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.0015))
    }

    func longPress() {
        setValue(UILongPressGestureRecognizer.State.began.rawValue, forKey: "state")
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.0015))
    }
}
