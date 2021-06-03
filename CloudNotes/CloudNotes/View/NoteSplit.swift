//
//  NoteSplit.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteSplit: UISplitViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setSplitViewController()
        expendSplitView()
    }
    
    private func setSplitViewController() {
        self.presentsWithGesture = false
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary
    }
    
    private func expendSplitView() {
        let primary = NoteList()
        let secondary = NoteDetail()
        self.viewControllers = [primary, secondary]
    }
}

extension NoteSplit: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
