//
//  Data.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

public typealias SaveData = (data: Data, key: String)

var jsonDecoder = JSONDecoder()
var jsonEncoder = JSONEncoder()
var defaults = UserDefaults.standard

func saveData(_ data: SaveData) {
    defaults.set(data.data, forKey: data.key)
}

func loadData(for key: String) -> Data? {
    if let data = defaults.object(forKey: key) as? Data {
        return data
    } else {
        return nil
    }
}
