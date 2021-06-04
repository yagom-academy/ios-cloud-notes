//
//  NoteSplitViewController.swift
//  CloudNotes
//
//  Created by Ryan-Son on 2021/06/03.
//

import UIKit

final class NoteSplitViewController: UISplitViewController {

    override init(style: UISplitViewController.Style) {
        super.init(style: style)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        preferredDisplayMode = .oneBesideSecondary
        preferredSplitBehavior = .tile
        super.delegate = self
    }
}

extension NoteSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(
        _ svc: UISplitViewController,
        topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column
    ) -> UISplitViewController.Column {
        return .primary
    }
}
