//
//  NoteSplit.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteSplitViewController: UISplitViewController {
    private var primary = NoteListViewController()
    private var secondary = NoteDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.primary.noteDelegate = self
        self.secondary.noteDelegate = self
        setSplitViewController()
    }
    
    private func setSplitViewController() {
        self.presentsWithGesture = false
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary
        self.viewControllers = [primary, secondary]
    }
}

extension NoteSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}

extension NoteSplitViewController: NoteDelegate {
    func deliverToPrimary(_ data: String) {
        if data == "" {
            primary.deleteEmptyNote()
        }
    }
    
    func deliverToDetail(_ data: Note) {
        secondary.displayData(data)
        self.showDetailViewController(secondary, sender: self)
    }
}
