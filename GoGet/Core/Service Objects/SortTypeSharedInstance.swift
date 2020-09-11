//
//  SortTypeSharedInstance.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/11/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Foundation

protocol SortingInstanceType {
  var sortType: SortType { get }
  func changeSortType(to method: SortType)
}

class SortingInstance: SortingInstanceType {
  static var shared = SortingInstance()
  var sortType: SortType = .added
  
  func changeSortType(to method: SortType) {
    sortType = method
  }
}
