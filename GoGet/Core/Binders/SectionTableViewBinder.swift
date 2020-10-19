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
//  let hideSectionIndexTitles: Bool

// The designated initializer
//
// - Parameters:
//
// - createCell: A closure that creates cell for a given table view and configures it with the given data
//  source at the given index path.
// - sectionIndexTitle: A closure that provides the section index title for the given section
// If `nil`, the section string itself is used as the title
// - hideSectionIndexTitles: Hides section indices if `true`. Returns `false` by default

public init(
  createCell: @escaping (Array2D<String, Data>, IndexPath, UITableView) -> UITableViewCell,
  sectionIndexTitle: ((Changeset.Collection.SectionMetadata) -> String)? = nil,
  hideSectionIndexTitles: Bool = false
  ) {
    self.sectionIndexTitle = sectionIndexTitle
//    self.hideSectionIndexTitles = hideSectionIndexTitles
    super.init(createCell)
  }
@objc func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
  guard let sections = changeset?.collection.sections, section < sections.count else {
    return nil
    }
    return sections[section].metadata
  }
//@objc func sectionIndexTitles(forTableView tableView: UITableView) -> [String]? {
//  guard !hideSectionIndexTitles else { return nil }
//  return changeset?.collection.sections.map { self.sectionIndexTitle?($0.metadata) ?? $0.metadata }
//  }
//@objc func tableView( _ tableView: UITableView,
//  sectionForSectionIndexTitle title: String, atIndex index: Int ) -> Int {
//    index
//    }
}
