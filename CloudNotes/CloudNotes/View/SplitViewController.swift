//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 천수현 on 2021/06/01.
//

import UIKit

class SplitViewController: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewControllers()
    }

    private func setViewControllers() {
        delegate = self
        preferredDisplayMode = .oneBesideSecondary

        let memoListViewController = MemoListViewController(splitViewDelegate: self)
        let memoDetailViewController = MemoDetailViewController(memoListViewDelegate: memoListViewController)

        viewControllers = [
            UINavigationController(rootViewController: memoListViewController),
            UINavigationController(rootViewController: memoDetailViewController)
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
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool { true }
}

extension SplitViewController: SplitViewDelegate {
    func didSelectRow(memo: Memo, indexPath: IndexPath, memoListViewDelegate: MemoListViewDelegate) {
        let memoDetailViewController = MemoDetailViewController(memoListViewDelegate: memoListViewDelegate)
        memoDetailViewController.fetchData(memo: memo, indexPath: indexPath)

        if traitCollection.horizontalSizeClass == .regular {
            showDetailViewController(UINavigationController(rootViewController: memoDetailViewController), sender: nil)
        } else {
            showDetailViewController(memoDetailViewController, sender: nil)
        }
    }
}
