//
//  NoteSplit.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteSplit: UISplitViewController {
    private var primary = NoteList()
    private var secondary = NoteDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.primary.noteDelegate = self
        setSplitViewController()
    }
    
    private func setSplitViewController() {
        self.presentsWithGesture = false
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary
        self.viewControllers = [primary, secondary]
    }
}

extension NoteSplit: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension NoteSplit: NoteDelegate {
    func deliverToDetail(_ data: NoteData) {
        secondary.noteData = data
        self.showDetailViewController(secondary, sender: self)
    }
}
