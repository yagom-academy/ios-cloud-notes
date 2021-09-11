//
//  MemoSplitViewController.swift
//  CloudNotes
//
//  Created by 김준건 on 2021/09/03.
//

import UIKit

class MemoSplitViewController: UISplitViewController {
    private let primary = MemoListViewController()
    private let secondary = MemoDetailViewController()
    private let linebreak = "\n\n"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        assignColumnsToChildVC(primary: primary, secondary: secondary, supplementary: nil)
        delegate = self
        primary.delegate = self
        secondary.delegate = self
    }
    
    private func assignColumnsToChildVC(primary: UIViewController, secondary: UIViewController, supplementary: UINavigationController?) {
        setViewController(primary, for: .primary)
        setViewController(secondary, for: .secondary)
        setViewController(supplementary, for: .supplementary)
    }
}

extension MemoSplitViewController: MemoSendable {
    func sendToListVC(memo: Memo) {
        primary.configureModifiedCell(by: memo)
    }
    
    func sendToDetailVC(memo: Memo) {
        secondary.configureTextView(by: memo)
        show(.secondary)
    }
}

extension MemoSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
