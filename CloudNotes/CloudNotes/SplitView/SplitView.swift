//
//  CloudNotes - SplitView.swift
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

        delegate = splitViewDelegator

        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        setViewController(memoListView, for: .primary)
        setViewController(memoDetailView, for: .secondary)

        memoListView.messenger = self
    }
}

extension SplitView: MessengerBetweenController {
    func showDetailViewController(with data: Memo?) {
        memoDetailView.configure(with: data)

        show(.secondary)
    }
}
