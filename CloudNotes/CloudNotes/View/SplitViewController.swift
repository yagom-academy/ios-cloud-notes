//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit

class SplitViewController: UISplitViewController {
    private var memoListViewController: MemoListViewController?
    private var memoDetailViewController: MemoDetailViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpMemoListViewController()
        setUpMemoDetailViewController()
        setUpSplitViewController()
        setUpMemoManager()
    }

    private func setUpMemoListViewController() {
        memoListViewController = MemoListViewController(splitViewDelegate: self)
    }

    private func setUpMemoDetailViewController() {
        guard let memoListViewController = memoListViewController else { return }
        memoDetailViewController = MemoDetailViewController(memoListViewDelegate: memoListViewController)
    }

    private func setUpSplitViewController() {
        guard let memoListViewController = memoListViewController,
              let memoDetailViewController = memoDetailViewController else { return }
        delegate = self
        preferredSplitBehavior = .tile
        preferredDisplayMode = .oneBesideSecondary

        viewControllers = [
            memoListViewController,
            memoDetailViewController
        ]
    }

    private func setUpMemoManager() {
        MemoManager.shared.memoListViewDelegate = memoListViewController
        MemoManager.shared.memoDetailViewDelegate = memoDetailViewController
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController,
                             topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension SplitViewController: SplitViewDelegate {
    func didSelectRow(memo: Memo, indexPath: IndexPath, memoListViewDelegate: MemoListViewDelegate) {
        guard let memoDetailViewController = memoDetailViewController else { return }
        memoDetailViewController.setUpData(memo: memo, indexPath: indexPath)
        showDetailViewController(memoDetailViewController, sender: self)

    }
}
