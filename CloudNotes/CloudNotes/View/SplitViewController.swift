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
        setSplitViewController()
    }

    private func setUpMemoListViewController() {
        memoListViewController = MemoListViewController(splitViewDelegate: self)
    }

    private func setUpMemoDetailViewController() {
        guard let memoListViewController = memoListViewController else {
            return
        }
        memoDetailViewController = MemoDetailViewController(memoListViewDelegate: memoListViewController)
    }
    private func setSplitViewController() {
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

    private func createSomeItems() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        for i in 1...10 {
            let newMemo = Memo(context: context)
            newMemo.title = "\(i) 글"
            newMemo.memoDescription = "\(i)번째 글입니다."
            try? context.save()
        }
    }

    private func deleteAllItems() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let memos: [Memo] = try? context.fetch(Memo.fetchRequest()) as [Memo] else { return }
        for memo in memos {
            context.delete(memo)
        }
        try? context.save()
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
        memoDetailViewController.fetchData(memo: memo, indexPath: indexPath)
        showDetailViewController(memoDetailViewController, sender: self)
    }
}
