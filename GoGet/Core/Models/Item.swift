//
//  Item.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

enum BoughtStatus: Equatable {
  case bought(_ date: Date)
  case notBought
}

struct Item: Codable {
  var name: String
  var id: String
  var quantity: Int
  var duration: Int
  var boughtStatus: BoughtStatus
  var dateAdded: Date?
  var categoryID: String?
}

extension Item {
  init(name: String,
       id: String = UUID().uuidString,
       quantity: Int,
       duration: Int,
       boughtStatus: BoughtStatus) {
    self.name = name
    self.id = id
    self.quantity = quantity
    self.duration = duration
    self.boughtStatus = boughtStatus
  }
}

extension BoughtStatus {
  enum CodingKeys: CodingKey {
    case bought, notBought
  }
}

extension BoughtStatus: Codable {
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)

    switch self {
    case .notBought:
      try container.encode(true, forKey: .notBought)
    case .bought(let date):
      try container.encode(date, forKey: .bought)
    }
  }
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let key = container.allKeys.first

    switch key {
    case .notBought:
      self = .notBought
    case .bought:
      let date = try container.decode(
        Date.self, forKey: .bought)
      self = .bought(date)
    default:
      throw DecodingError.dataCorrupted(
        DecodingError.Context(
          codingPath: container.codingPath,
          debugDescription: "Unable to decode enum."))
    }
  }
}
