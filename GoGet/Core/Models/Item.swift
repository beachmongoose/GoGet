//
//  Item.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

enum BoughtStatus {
  case bought(Date)
  case notBought
}


struct Item: Codable {
  var name: String
  var quantity: Int
  var boughtStatus: BoughtStatus
  var duration: Int
  var dateAdded: Date?
  var id: String
  var categoryID: String?
}

extension Item {
  init(name: String, quantity: Int, dateBought: Date?, duration: Int, bought: Bool, id: String = UUID().uuidString, dateBought: Date?) {
  self.name = name
    
  
  self.quantity = quantity
  self.duration = duration
  self.bought = bought
  self.id = id
  }
}
