# GoGet

A iOS reactive-style shopping list for keeping track of what to buy and when.

## Overview
GoGet will remember when you last bought something, even if you dont.

User inputs items that they plan to buy, including how many of the item, and how often the item should be bought.

User can also create categories to sort items into. Items not in a category will appear under the heading Uncategorized.

On the Category menu, new Categories can be added. Pressing and holding on a category's cell will allow User to Rename or Delete it. Any items in a deleted category will become Uncategorized.

All items are visible in the Full List tab. Tapping an item will allow the user to edit its details. Pressing and holding an item will activate Delete Mode. In this mode, tap other items to also select them. User then can press Confirm to delete all selected items, or Cancel to exit the mode.

The Buy List tab will populate only with items that have not been bought, or are past their buy interval.

When shopping, user can check off items as they go. Once they've completed their shopping trip, clicking the "Bought" button changes all checked items' status to Bought and resets their interval counters.

## Development
GoGet is programmed with an MVVM-C design pattern, with a view model for each tab and custom cell.

The Detail View has two view models. New, for creating new items, and Edit, for when an item is being edited.

Data displayed in the View Controllers are bound to data within the View Models, which update depending on user input.

UIAlerts are controlled by the ViewModel, but are sent to the View Controller via a SafePassThroughSubject.

Each tab's view is built with a standard View Controller, with a Table View added via XIB file. The Buy List, Full List, and Category List each have their own custom cell. The Detail View has one custom cell for each input line.

## Required Pods:
- Bond
- PromiseKit
- ReactiveKit
- SwiftLint
- Quick & Nimble (Unit Testing Only)

## Planned Changes
- Select All button
- Sort by Category option
- Implement custom headers
- Allow user to change font style and background color

## Contributing
Anyone is welcome to contribute or suggest improvements.

## Acknowledgements
Special thanks to [Kevin Maldjian](https://github.com/KevinMaldjian/)
