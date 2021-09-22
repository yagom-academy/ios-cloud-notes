//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by Do Yi Lee on 2021/09/05.
//

import UIKit

final class SplitViewController: UISplitViewController {
    private let detailVC = MemoDetailViewController()
    private let primaryVC = MemoListViewController()
     
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decideSpliveVCPreferences()
        self.delegate = self
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
            return .primary
        }
    
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
        svc.presentsWithGesture = false
    }
}

extension SplitViewController {
    private func decideSpliveVCPreferences() {
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .displace
        self.setViewController(primaryVC, for: .primary)
        self.setViewController(detailVC, for: .secondary)
    }
}
