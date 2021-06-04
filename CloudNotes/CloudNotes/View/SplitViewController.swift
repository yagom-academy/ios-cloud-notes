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

    func setViewControllers() {
        delegate = self
        preferredDisplayMode = .oneBesideSecondary

        let memoListViewController = UINavigationController(rootViewController: MemoListViewController(splitViewDelegate: self))
        let memoDetailViewController = UINavigationController(rootViewController: MemoDetailViewController())

        viewControllers = [ memoListViewController, memoDetailViewController ]
    }

    func createSomeItems() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        for i in 1...10 {
            let newMemo = Memo(context: context)
            newMemo.title = "\(i) 글"
            newMemo.memoDescription = "\(i)번째 글입니다."
            try? context.save()
        }
    }

    func deleteAllItems() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext,
              let memos: [Memo] = try? context.fetch(Memo.fetchRequest()) as [Memo] else { return }
        for memo in memos {
            try? context.delete(memo)
        }
        try? context.save()
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool { true }
}

protocol SplitViewDelegate: class {
    func didSelectRow(memo: Memo)
}

extension SplitViewController: SplitViewDelegate {
    func didSelectRow(memo: Memo) {
        let memoDetailViewController = MemoDetailViewController()
        memoDetailViewController.fetchData(memo: memo)

        showDetailViewController(UINavigationController(rootViewController: memoDetailViewController), sender: nil)
    }
}
