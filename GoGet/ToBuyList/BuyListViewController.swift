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

// MARK: - Populate Table
extension BuyListViewController: UITableViewDataSource, UITableViewDelegate {

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
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    changeStatePrompt(indexPath.row)
    self.tableView.reloadData()
  }
  
  func changeStatePrompt(_ index: Int) {
    let markBoughtPrompt = UIAlertController(title: "Mark as Bought?", message: nil, preferredStyle: .alert)
    markBoughtPrompt.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
      self.viewModel.markAsBought(index)
      self.tableView.reloadData()
    }))
    markBoughtPrompt.addAction(UIAlertAction(title: "No", style: .cancel))
    present(markBoughtPrompt, animated: true)
  }
}

// MARK: - Navigation
extension BuyListViewController {
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
  
  override func viewWillAppear(_ animated: Bool) {
    tableView.reloadData()
  }
}
