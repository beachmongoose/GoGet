//
//  HeaderCellViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 11/10/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

protocol HeaderCellViewModelType {
  var title: String { get }
}

struct HeaderCellViewModel {
  var title: String

  init(title: String) {
    self.title = title
  }
}
