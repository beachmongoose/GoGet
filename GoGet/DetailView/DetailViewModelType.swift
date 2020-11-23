//
//  DetailViewModelProtocol.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/21/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol DetailViewModelType {
    var bought: Property<Bool> { get }
    var categoryID: Property<String?> { get }
    var isValid: Property<Bool> { get }
    var newItem: Bool { get }
    var tableData: MutableObservableArray<CellType> { get }

    func clearDetails()
    func observeValidationUpdates()
    func presentPopover(selectedID: Property<String?>)
    func saveItem()
}
