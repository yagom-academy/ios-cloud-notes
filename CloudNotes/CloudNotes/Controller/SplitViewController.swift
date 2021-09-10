//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    // MARK: Property
    private let memoListViewController = MemoListTableViewController()
    private let memoDetailViewController = MemoDetailViewController()
    
    // MARK: View LifeCycle
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
        memoListViewController.delegate = self
        setViewController(memoListViewController, for: .primary)
        setViewController(memoDetailViewController, for: .secondary)
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

extension SplitViewController: MemoListDelegate {
    func didTapTableViewCell(at indexPath: IndexPath) {
        let currentObject = CoreDataCloudMemo.shared.fetchedController.object(at: indexPath)
        memoDetailViewController.configure(currentObject)
        show(.secondary)
    }
    
    func didTapAddButton() {
        let newMemo = CoreDataCloudMemo.shared.createNewMemo()
        memoDetailViewController.configure(newMemo)
        show(.secondary)
    }
}
