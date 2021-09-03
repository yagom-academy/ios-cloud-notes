//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoSplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredDisplayMode = .oneBesideSecondary
        self.preferredSplitBehavior = .tile
        assignColumnsToChildVC(primary: MemoListViewController(), secondary: MemoDetailViewController(), supplementary: nil)
        self.delegate = self
    }
    
    private func assignColumnsToChildVC(primary: UIViewController, secondary: UIViewController, supplementary: UINavigationController?) {
        setViewController(primary, for: .primary)
        setViewController(secondary, for: .secondary)
        setViewController(supplementary, for: .supplementary)
    }
}

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
