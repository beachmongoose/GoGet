//
//  Item+UserDefaults.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

// MARK: - Mutation
extension Array where Element == Item {
  var persistenceData: (Data, String)? {
    let json = JSONEncoder()
    guard let data = try? json.encode(self) else {
      return nil
    }
    return (data, "Items")
  }
}

extension Array where Element == Category {
  var persistenceData: SaveData? {
    let json = JSONEncoder()
    guard let data = try? json.encode(self) else {
      return nil
    }
    return (data, "Categories")
  }
}
