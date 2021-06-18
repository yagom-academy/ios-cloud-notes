//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by duckbok on 2021/06/16.
//

import UIKit

final class MemoSplitViewController: UISplitViewController {

    // MARK: Property

    var memoData: MemoData = MemoData.sample

    // MARK: UI

    private let memoListViewController = MemoListViewController()
    private let memoViewController = MemoViewController()

    // MARK: Initializer

    init() {
        super.init(style: .doubleColumn)
        configure()
        configureChildren()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: Configure

    private func configure() {
        delegate = self
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
        setViewController(memoListViewController, for: .primary)
        setViewController(memoViewController, for: .secondary)
    }

    private func configureChildren() {
        memoListViewController.delegate = memoViewController
        memoViewController.delegate = memoListViewController
    }

}

// MARK: - UISplitViewControllerDelegate

extension MemoSplitViewController: UISplitViewControllerDelegate {

    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return memoViewController.isTextViewHidden ? .primary : .secondary
    }

}
