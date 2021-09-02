//
//  CloudNotes - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SplitView: UISplitViewController {

    let itemListView = ItemListView()
    let itemDetailView = ItemDetailView()
    let splitViewDelegator = SplitViewDelegate()

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = splitViewDelegator

        view.backgroundColor = .orange

        setViewController(itemListView, for: .primary)
        setViewController(itemDetailView, for: .secondary)
    }
}
