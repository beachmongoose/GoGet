//
//  Item.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

struct Item: Codable {
  var name: String
  var quantity: Int
  var dateBought: Date
  var duration: Int
  var bought: Bool
}
