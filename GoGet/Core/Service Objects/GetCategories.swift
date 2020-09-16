//
//  GetExtensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/16/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

func saveCategories(_ categories: [Category]) {
  guard let persistenceData = categories.persistenceData else {
    print("Error")
    return
    }
    saveData(persistenceData)
  }
