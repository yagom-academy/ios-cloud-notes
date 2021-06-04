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
        setWithPreferredStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setWithPreferredStyle()
    }
    
    private func setWithPreferredStyle() {
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

extension NoteSplitViewController: NoteShowable {
    func showNote(with note: Note) {
        guard let noteDetailViewController = self.viewController(for: .secondary) as? NoteDetailViewController else {
            os_log(
                .error,
                log: .ui,
                OSLog.objectCFormatSpecifier,
                UIError.downcastingFailed("Secondary view controller", #function).localizedDescription
            )
            return
        }
        noteDetailViewController.setContent(with: note)
        noteDetailViewController.updateUI()
        noteDetailViewController.noteTextView.resignFirstResponder()
        showDetailViewController(noteDetailViewController, sender: nil)
    }
}
