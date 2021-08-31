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
        setViewController(MemoListViewController(style: .plain), for: .primary)
        setViewController(MemoDatailViewController(), for: .secondary)
    }
    func setupSplitViewDisPlayMode() {
        preferredDisplayMode = .oneBesideSecondary
        presentsWithGesture = false
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
