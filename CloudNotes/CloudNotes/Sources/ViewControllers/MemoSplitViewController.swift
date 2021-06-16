//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/16.
//

import UIKit

final class MemoSplitViewController: UISplitViewController {

    // MARK: UI

    private let memoListViewController = MemoListViewController()
    private let memoViewController = MemoViewController()

    // MARK: Initializer

    init() {
        super.init(style: .doubleColumn)
        delegate = memoViewController
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        setViewController(memoListViewController, for: .primary)
        setViewController(memoViewController, for: .secondary)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
