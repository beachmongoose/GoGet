//
//  BuyListViewModel.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/4/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

protocol BuyListViewModelType {
  var tableData: [Item] { get }
}

final class BuyListViewModel: BuyListViewModelType {
  var tableData: [Item] = []
  
  
}
