//
//  CloudNotes - ViewController.swift
//  Created by yagom.
//  Copyright © yagom. All rights reserved.
//

import UIKit

class SplitView: UISplitViewController {

    private let memoListView = MemoListView()
    private let memoDetailView = MemoDetailView()
    private let splitViewDelegator = SplitViewDelegate()

    private var isCompactSize: Bool {
        return UITraitCollection.current.horizontalSizeClass == .compact
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        delegate = splitViewDelegator

        setViewController(memoListView, for: .primary)
        setViewController(memoDetailView, for: .secondary)
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        if isCompactSize {
            navigationController?.isNavigationBarHidden = true
        } else {
            navigationController?.isNavigationBarHidden = false
        }
    }

    func showDetailViewController(with data: Memo?) {
        memoDetailView.configure(with: data)

        show(.secondary)
    }
}
