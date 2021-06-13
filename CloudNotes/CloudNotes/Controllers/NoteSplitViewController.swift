//
//  NoteSplitViewController.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit
import OSLog

final class NoteSplitViewController: UISplitViewController {

    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        
        setSubViewControllers()
        setWithPreferredStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setSubViewControllers()
        setWithPreferredStyle()
    }
    
    private func setWithPreferredStyle() {
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        super.delegate = self
    }
    
    private func setSubViewControllers() {
        let sideBarViewController = NoteListViewController()
        let secondaryViewController = NoteDetailViewController()
        secondaryViewController.noteListViewControllerActionsDelegate = sideBarViewController
        
        setViewController(sideBarViewController, for: .primary)
        setViewController(secondaryViewController, for: .secondary)
    }
}

extension NoteSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
