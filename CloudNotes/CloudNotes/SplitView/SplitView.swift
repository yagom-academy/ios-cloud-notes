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

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if isCompactSize {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
        }
    }

    func sendDataToDetailVC(_ data: Memo?) {
        if let memo = data {
            itemDetailView.configure(memo)
        }

        show(.secondary)
    }
}
