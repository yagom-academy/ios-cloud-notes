//
//  NoteSplit.swift
//  CloudNotes
//
//  Created by 윤재웅 on 2021/06/03.
//

import UIKit

class NoteSplit: UISplitViewController {
    var noteList: NoteList!
    var noteDetail: NoteDetail!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        noteList = NoteList()
        noteDetail = NoteDetail()

        self.presentsWithGesture = false
        self.preferredSplitBehavior = .tile
        self.preferredDisplayMode = .oneBesideSecondary
        
        viewControllers = [noteList, noteDetail]
    }
}

extension NoteSplit: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
