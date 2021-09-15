//
//  CloudNotes - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setUpSplitView()
        initChildViewControllers()
        NotificationCenter.default
            .addObserver(self, selector: #selector(deleteSecondary), name: .deleteNotification, object: nil)
    }
    
    private func initChildViewControllers() {
        let primaryViewController = NoteListViewController()
        let secondaryViewController = NoteDetailViewController()
        let primaryChild = UINavigationController(rootViewController: primaryViewController)
        let secondaryChild = UINavigationController(rootViewController: secondaryViewController)
        
        setViewController(primaryChild, for: .primary)
        setViewController(secondaryChild, for: .secondary)
    }
    
    private func setUpSplitView() {
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        presentsWithGesture = false
    }
    
    @objc func deleteSecondary() {
        setViewController(nil, for: .secondary)
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
