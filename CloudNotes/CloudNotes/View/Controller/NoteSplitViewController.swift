//
//  NoteSplit.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

final class NoteSplitViewController: UISplitViewController {
    private var primary = NoteListViewController()
    private var secondary = NoteDetailViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.primary.noteDelegate = self
        self.secondary.noteDelegate = self
        NoteManager.shared.coreDataDelegate = self
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
    func clearNote() {
        self.secondary.clearTextView()
    }
    
    func backToPrimary() {
        self.show(.primary)
    }
    
    func deliverToPrimary(_ data: UITextView, first: Bool, index: IndexPath?) {
        if data.text == "" {
            self.primary.textViewIsEmpty(first)
        } else {
            self.primary.updateTextToCell(data.text, isTitle: false, index: index)
        }
    }
    
    func deliverToDetail(_ data: Note?, first: Bool, index: IndexPath) {
        secondary.displayData(data, first: first, index: index)
        self.showDetailViewController(secondary, sender: self)
    }
}

extension NoteSplitViewController: CoreDataDelegate {
    func insert(current: IndexPath?, new: IndexPath?) {
        self.primary.insertCell(indexPath: current, newIndexPath: new)
    }
    
    func delete(current: IndexPath?, new: IndexPath?) {
        self.primary.deleteCell(indexPath: current, newIndexPath: new)
    }
    
    func move(current: IndexPath?, new: IndexPath?) {
        self.primary.moveCell(indexPath: current, newIndexPath: new)
    }
    
    func update(current: IndexPath?, new: IndexPath?) {
        let data = NoteManager.shared.specify(current)
        self.primary.updateCell(indexPath: current, newIndexPath: new, data: data)
    }
}
