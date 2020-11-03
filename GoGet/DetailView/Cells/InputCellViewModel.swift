//
//  InputCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/29/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

public typealias SafePassthroughSubject<Element> = PassthroughSubject<Element, Never>

protocol InputCellViewModelType {
    var title: String { get }
    var initialValue: String { get }
    var updatedValue: Property<String?> { get }
    var isValid: Property<Bool> { get }
//    var validationSignal: SafePassthroughSubject<Void> { get }
}
