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
    var itemSortAscending: Property<Bool> { get }
    var categorySortAscending: Property<Bool> { get }
    func changeSortType(to method: SortType)
    func changeCategoryOrder()
}

class SortingInstance: SortingInstanceType {

    var bag = DisposeBag()
    static var shared = SortingInstance()
    var itemSortType = Property<SortType>(.added)
    var itemSortAscending = Property<Bool>(true)
    var categorySortAscending = Property<Bool>(true)

    init() {
        load()
        observeSortTypes()
    }

    func changeSortType(to method: SortType) {
        if method == itemSortType.value {
            itemSortAscending.value.toggle()
        } else {
            itemSortAscending.value = true
        }
        itemSortType.value = method
    }
    func changeCategoryOrder() {
        categorySortAscending.value.toggle()
    }

    func load() {
        let data = loadData(for: "SortPreferences")
        guard data != nil else { return }
        do {
            let preferences = try jsonDecoder.decode(SortPreferences.self, from: data!)
            itemSortType.value = preferences.itemSortType
            itemSortAscending.value = preferences.itemSortAscending
            categorySortAscending.value = preferences.categorySortAscending
        } catch {
            print("Failed to load SortPreferences")
        }
    }
    func observeSortTypes() {
        let sortSelections = combineLatest(itemSortType, itemSortAscending, categorySortAscending)
        sortSelections.observeNext { [weak self] _, _, _ in
            self?.savePreferences()
        }
        .dispose(in: bag)
    }

    func savePreferences() {
        let preferences = SortPreferences(itemSortType: itemSortType.value,
                                          itemSortAscending: itemSortAscending.value,
                                          categorySortAscending: categorySortAscending.value)
        guard let persistenceData = preferences.persistenceData else {
            print("Unable to save sorting preferences")
            return
        }
        saveData(persistenceData)
    }
}

struct SortPreferences: Codable {
    var itemSortType: SortType
    var itemSortAscending: Bool
    var categorySortAscending: Bool
}

extension SortPreferences {
    static func == (lhs: SortPreferences, rhs: SortPreferences) -> Bool {
        return lhs.itemSortType == rhs.itemSortType && lhs.itemSortAscending == rhs.itemSortAscending && lhs.categorySortAscending == rhs.categorySortAscending
    }
}

//extension SortPreferences {
//    init(itemSortType: SortType,
//         itemSortAscending: Bool,
//         categorySortAscending: Bool) {
//        self.itemSortType = itemSortType
//        self.itemSortAscending = itemSortAscending
//        self.categorySortAscending = categorySortAscending
//    }
