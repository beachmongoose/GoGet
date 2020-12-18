//
//  SortType.swift
//  GoGet
//
//  Created by Maggie Maldjian on 12/18/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

enum SortType: String {
    case name
    case date
    case added
}

extension SortType {
    enum SortingKey: CodingKey {
        case rawValue
    }
}

extension SortType: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SortingKey.self)
        switch self {
        case .name:
            try container.encode(0, forKey: .rawValue)
        case .date:
            try container.encode(1, forKey: .rawValue)
        case .added:
            try container.encode(2, forKey: .rawValue)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: SortingKey.self)
        let rawValue = try container.decode(Int.self, forKey: .rawValue)
        switch rawValue {
        case 0:
            self = .name
        case 1:
            self = .date
        case 2:
            self = .added
        default:
            fatalError("Unable to decode SortType")
        }
    }
}
