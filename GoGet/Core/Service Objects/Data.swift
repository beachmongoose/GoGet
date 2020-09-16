//
//  Data.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

public typealias SaveData = (data: Data, key: String)

func saveData(_ data: SaveData) {
    let defaults = UserDefaults.standard
  defaults.set(data.data, forKey: data.key)
  }
