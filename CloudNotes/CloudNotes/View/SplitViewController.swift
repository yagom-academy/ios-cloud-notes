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
        guard memoListViewController != nil else { return }
        memoDetailViewController = MemoDetailViewController(splitViewDelegate: self)
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
        MemoManager.shared.splitViewDelegate = self
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
    func didSelectRow(indexPath: IndexPath, memoListViewDelegate: MemoListViewDelegate) {
        guard let memoDetailViewController = memoDetailViewController,
              let memo = MemoManager.shared.memos?[indexPath.row] else { return }

        memoDetailViewController.setUpData(memo: memo, indexPath: indexPath)
        showDetailViewController(memoDetailViewController, sender: self)
    }

    func showAlert(alert: UIAlertController) {
        present(alert, animated: true, completion: nil)
    }

    func showActivityView(indexPath: IndexPath, sourceView: UIView) {
        guard let memos = MemoManager.shared.memos else { return }

        let activityView = UIActivityViewController(activityItems: [memos[indexPath.row].title],
                                                    applicationActivities: nil)

        if UIDevice.current.userInterfaceIdiom == .pad {
            let popOverPresentationController = activityView.popoverPresentationController
            popOverPresentationController?.sourceView = sourceView
        }

        present(activityView, animated: true)
    }
}
