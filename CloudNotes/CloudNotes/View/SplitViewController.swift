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
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController) -> Bool { true }
}

protocol SplitViewDelegate: class {
    func didSelectRow(data: SampleMemo)
}

extension SplitViewController: SplitViewDelegate {
    func didSelectRow(data: SampleMemo) {
        let sampleData = data
        let memoDetailViewController = MemoDetailViewController()
        memoDetailViewController.setDescriptionTextView(text: sampleData.description)

        showDetailViewController(UINavigationController(rootViewController: memoDetailViewController), sender: nil)
    }
}
