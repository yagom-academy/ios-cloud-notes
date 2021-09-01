//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupChildViewController()
        setupSplitViewDisPlayMode()
        delegate = self
    }

}

extension SplitViewController {
    func setupChildViewController() {
        setViewController(MemoListTableViewController(isCompact: false), for: .primary)
        setViewController(UINavigationController(rootViewController: MemoDatailViewController()), for: .secondary)
        setViewController(UINavigationController(rootViewController: MemoListTableViewController(isCompact: true)), for: .compact)
    }

    func setupSplitViewDisPlayMode() {
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .compact
    }
}
