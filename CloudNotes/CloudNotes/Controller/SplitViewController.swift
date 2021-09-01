//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    // MARK: - View LifeCycle
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
        setViewController(MemoListTableViewController(), for: .primary)
        setViewController(MemoDatailViewController(), for: .secondary)
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
