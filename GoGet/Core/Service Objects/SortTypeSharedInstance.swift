//
//  SortTypeSharedInstance.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import Foundation
import ReactiveKit

protocol SortingInstanceType {
    var itemSortType: Property<SortType> { get }
    var itemSortAscending: Bool { get }
    var categorySortType: Property<SortType> { get }
    var categorySortAscending: Bool { get }
    func changeSortType(to method: SortType)
    func changeCategorySortType(to method: SortType)
}

class SortingInstance: SortingInstanceType {

    static var shared = SortingInstance()
    var itemSortType = Property<SortType>(.added)
    var itemSortAscending = true
    var categorySortType = Property<SortType>(.added)
    var categorySortAscending = true

    func changeSortType(to method: SortType) {
        if method == itemSortType.value {
            itemSortAscending.toggle()
        } else {
            itemSortAscending = true
        }
        itemSortType.value = method
    }
    func changeCategorySortType(to method: SortType) {
        if method == categorySortType.value {
            categorySortAscending.toggle()
        } else {
            categorySortAscending = true
        }
        categorySortType.value = method
    }
}
