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

    var isCompactSize: Bool {
        return UITraitCollection.current.horizontalSizeClass == .compact
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredSplitBehavior = .tile
        preferredDisplayMode = .automatic

        delegate = splitViewDelegator

        setViewController(itemListView, for: .primary)
        setViewController(itemDetailView, for: .secondary)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if isCompactSize {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
        }
    }
}
