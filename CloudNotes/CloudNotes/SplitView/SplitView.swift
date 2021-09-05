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

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        delegate = splitViewDelegator

        setViewController(memoListView, for: .primary)
        setViewController(memoDetailView, for: .secondary)
    }

    func showDetailViewController(with data: Memo?) {
        memoDetailView.configure(with: data)

        show(.secondary)
    }
}
