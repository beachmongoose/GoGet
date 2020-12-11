//
//  SectionTableViewBinder.swift
//  GoGet
//
//  Created by Maggie Maldjian on 9/28/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
import ReactiveKit

// swiftlint:disable:next line_length
public final class SectionedTableViewBinderDataSource<Data>: TableViewBinderDataSource<TreeChangeset<Array2D<String, Data>>> {
  public typealias Changeset = TreeChangeset<Array2D<String, Data>>
  let sectionIndexTitle: ((Changeset.Collection.SectionMetadata) -> String)?

public init(
  createCell: @escaping (Array2D<String, Data>, IndexPath, UITableView) -> UITableViewCell,
  sectionIndexTitle: ((Changeset.Collection.SectionMetadata) -> String)? = nil,
  hideSectionIndexTitles: Bool = false
  ) {
    self.sectionIndexTitle = sectionIndexTitle
    super.init(createCell)
  }
@objc func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  guard let sections = changeset?.collection.sections, section < sections.count else {
    return nil
    }
    return sections[section].metadata
  }
}

//public final class TableViewBinderDataSource<Data>: TableViewBinderDataSource<TreeChangeset<Data>> {
//    public typealias CategoryChangeset = TreeChangeset<Data>
//    public init(
//        createCell: @escaping([Data], IndexPath, UITableView) -> UITableViewCell) {
//        super.init(createCell)
//    }
//}
