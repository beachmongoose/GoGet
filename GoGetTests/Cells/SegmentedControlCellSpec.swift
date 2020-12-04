//
//  SegmentedControlCellSpec.swift
//  GoGetTests
//
//  Created by Maggie Maldjian on 12/3/20.
//  Copyright © 2020 Maggie Maldjian. All rights reserved.
//

import Bond
@testable import GoGet
import Nimble
import Quick
import ReactiveKit

class SegmentedControllCellSpec: QuickSpec {
    var viewModel: MockSegmentedControlCellViewModel!
}

final class MockSegmentedControlCellViewModel: SegmentedControlCellViewModelType {
    var title = ""
    
    var initialValue = false
    
    var updatedValue = Property<Bool>(false)
    
}
