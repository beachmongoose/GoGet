//
//  UITableView+Extensions.swift
//  GoGet
//
//  Created by Maggie Maldjian on 10/26/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import UIKit

extension UITableView {
    // Registers a nib object containing a cell with the table view under a specified identifier.
    public func registerForCellReuse(_ view: UIView.Type) {
        register(view.nib(bundle: Bundle(for: view)), forCellReuseIdentifier: view.reuseIdentifier)
    }
    // Dequeues a cell for the specified indexPath. Cell must be registered beforehand.
    public func dequeueReusableCell<Cell: UITableViewCell>(_ view: Cell.Type, for indexPath: IndexPath) -> Cell {
        guard let cell = dequeueReusableCell(withIdentifier: view.reuseIdentifier, for: indexPath) as? Cell else {
            print("Unrecoverable, Failed to dequeue cell. Cell type: \(Cell.self), indexPath: \(indexPath)")
            return Cell()
        }
        return cell
    }
    public func registerCellsForReuse(_ views: [UIView.Type]) {
        views.forEach { register($0.nib(bundle: Bundle(for: $0)), forCellReuseIdentifier: $0.reuseIdentifier) }
  }
}
