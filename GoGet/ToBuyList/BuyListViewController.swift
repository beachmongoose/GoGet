//
//  ExpiredListViewController.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/1/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

class BuyListViewController: UIViewController {
  @IBOutlet var tableView: UITableView!
  
  private let viewModel: BuyListViewModelType
    
  init(viewModel: BuyListViewModelType) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
      setUpNavButton()
      tableView.register(UINib(nibName: "BuyListCell", bundle: nil), forCellReuseIdentifier: "BuyListCell")
      title = "GoGet"
      super.viewDidLoad()
    }

}

extension BuyListViewController: UITableViewDataSource, UITableViewDelegate {
  
    func setUpNavButton() {
      let fullList = UIBarButtonItem(
        barButtonSystemItem: .organize,
        target: self,
        action: #selector(presentFullList))
      navigationItem.rightBarButtonItem = fullList
    }
  
  @objc func presentFullList() {
    viewModel.presentFullList()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tableData.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(
      withIdentifier: "BuyListCell",
      for: indexPath)
      as? BuyListCell else {
        fatalError("Unable to Dequeue")
      }
    
    let item = viewModel.tableData[indexPath.row]
    cell.item.text = item.name
    cell.dateBought.text = item.buyData

    return cell
  }
}
