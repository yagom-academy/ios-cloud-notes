//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 이차민 on 2022/02/08.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    private var memoTableViewController = MemoTableViewController(style: .insetGrouped)
    private var memoDetailViewController = MemoDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSplitViewController()
        delegate = self
    }
    
    private func configureSplitViewController() {
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary
        setViewController(memoTableViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
    }
    
    func showSecondaryView(with memo: Memo, indexPath: IndexPath) {
        memoDetailViewController.updateMemo(text: memo.body)
        memoDetailViewController.updateCurrentIndexPath(with: indexPath)
        show(.secondary)
    }
    
    func deleteMemo(at indexPath: IndexPath) {
        memoTableViewController.presentDeleteAlert(at: indexPath)
    }
    
    func showPrimaryView() {
        show(.primary)
    }
}

// MARK: - UISplitViewControllerDelegate

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
