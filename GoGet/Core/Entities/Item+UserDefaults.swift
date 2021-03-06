//
//  Item+UserDefaults.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

// MARK: - Mutation
extension Array where Element == GoGet.Item {
    var persistenceData: SaveData? {
        guard let data = try? jsonEncoder.encode(self) else {
            return nil
        }
        return (data, "Items")
    }
}

extension Array where Element == Category {
    var persistenceData: SaveData? {
        guard let data = try? jsonEncoder.encode(self) else {
            return nil
        }
        return (data, "Categories")
    }
}

extension SortPreferences {
    var persistenceData: SaveData? {
        guard let data = try? jsonEncoder.encode(self) else {
            return nil
        }
        return (data, "SortPreferences")
    }
}
