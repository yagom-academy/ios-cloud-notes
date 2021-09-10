//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    // MARK: Property
    private let memoListViewController = MemoListTableViewController()
    private let memoDetailViewController = MemoDetailViewController()

    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewController()
        setupSplitViewDisPlayMode()
        delegate = self
    }
    
}

// MARK: - SplitView Setup
extension SplitViewController {
    private func setupChildViewController() {
        memoListViewController.delegate = self
        setViewController(memoListViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
    }
    
    private func setupSplitViewDisPlayMode() {
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
}

// MARK: - SplitViewController Delegate
extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension SplitViewController: MemoListDelegate {
    func didTapTableViewCell(_ memo: Memo?) {
        memoDetailViewController.showContents(of: memo)
        show(.secondary)
    }
    
    func didTapAddButton() {
        memoDetailViewController.showContents(of: nil)
        show(.secondary)
    }
}
